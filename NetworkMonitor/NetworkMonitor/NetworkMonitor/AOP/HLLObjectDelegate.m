//
//  HLLObjectDelegate.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLObjectDelegate.h"
#import "HLLCache.h"
#import "NSHTTPURLResponse+Helper.h"
#import "NSData+GZIP.h"
#import <UIKit/UIKit.h>


@interface HLLObjectDelegate()

@property (nonatomic, strong) NSMutableArray *selList;

@end


@implementation HLLObjectDelegate

- (NSMutableArray *)selList {
    if (!_selList) {
        _selList = [NSMutableArray arrayWithCapacity:0];
    }
    return _selList;
}

- (void)invoke:(NSInvocation *)invocation {
    if (![HLLNetUtils isHLLNetworkMonitorOn] || invocation.selector == @selector(respondsToSelector:)) {
        return;
    }
    if ([self.selList containsObject:NSStringFromSelector(invocation.selector)]) {
        if ([self respondsToSelector:invocation.selector]) {
            invocation.target = self;
            [invocation invoke];
        }
    }
}

- (void)registerSelector:(NSString *)selector {
    if (![self.selList containsObject:selector]) {
        [self.selList addObject:selector];
    }
}

- (void)unregisterSelector:(NSString *)selector {
    if ([self.selList containsObject:selector]) {
        [self.selList removeObject:selector];
    }
}

#pragma mark-NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
        return;
    }
    NSURLSessionTaskTransactionMetrics *metric = [metrics.transactionMetrics lastObject];
    NSString *traceId = metric.request.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (!traceId) {
       
        return;
    }
    if (metric) {
        //请求开始时间
        NSString *sreq = [NSString stringWithFormat:@"%.f", [metric.fetchStartDate timeIntervalSince1970] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:sreq key:NMDATA_KEY_STARTREQUEST traceId:traceId];
        //域名解析时间
        NSString *dnst = [NSString stringWithFormat:@"%.f", [metric.domainLookupEndDate timeIntervalSinceDate:metric.domainLookupStartDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:dnst key:NMDATA_KEY_DNSTIME traceId:traceId];
        //连接建立时间
        NSString *cnnt = [NSString stringWithFormat:@"%.f", [metric.connectEndDate timeIntervalSinceDate:metric.connectStartDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:cnnt key:NMDATA_KEY_CONNTIME traceId:traceId];
        //https ssl验证时间
        NSString *sslt = [NSString stringWithFormat:@"%.f", [metric.secureConnectionEndDate timeIntervalSinceDate:metric.secureConnectionStartDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:sslt key:NMDATA_KEY_SSLTIME traceId:traceId];
        //从客户端发送HTTP请求到服务器所耗费的时间
        NSString *sdt = [NSString stringWithFormat:@"%.f", [metric.requestEndDate timeIntervalSinceDate:metric.requestStartDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:sdt key:NMDATA_KEY_SENDTIME traceId:traceId];
        //响应报文首字节到达时间
        NSString *wtt = [NSString stringWithFormat:@"%.f", [metric.responseStartDate timeIntervalSinceDate:metric.requestEndDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:wtt key:NMDATA_KEY_WAITTIME traceId:traceId];
        //客户端从开始接收数据到接收完所有数据的时间
        NSString *rcvt = [NSString stringWithFormat:@"%.f", [metric.responseEndDate timeIntervalSinceDate:metric.responseStartDate] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:rcvt key:NMDATA_KEY_RECEIVETIME traceId:traceId];
        //请求结束时间
        NSString *eres = [NSString stringWithFormat:@"%.f", [metric.responseEndDate timeIntervalSince1970] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:eres key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
        //网络请求总时间
        NSString *ttt = [NSString stringWithFormat:@"%.f", [metrics.taskInterval duration] * 1000];
        [[HLLCache sharedHLLCache] cacheValue:ttt key:NMDATA_KEY_TOTALTIME traceId:traceId];
    }
   
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = task.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (!traceId) {
       
        return;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//iOS 10.0以下系统版本处理
    if (![HLLNetUtils isAbove_iOS_10_0]) {
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    }
    NSString *ress;
    NSUInteger statusLineSize = httpResponse.statusLineSize;
    NSUInteger headerSize = httpResponse.headerSize;
    NSData *data = [[HLLCache sharedHLLCache] getDataByTraceId:traceId];
    if ([[httpResponse.allHeaderFields objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
        // 模拟压缩
        data = [data gzippedData];
    }
    
    NSUInteger bodySize = data.length;
    NSInteger statusCode = httpResponse.statusCode;
    if (error) {
        [[HLLCache sharedHLLCache] cacheValue:@"1" key:NMDATA_KEY_ERRORTYPE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%d", (int)error.code] key:NMDATA_KEY_ERRORCODE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:error.description key:NMDATA_KEY_ERRORDETAIL traceId:traceId];
        if ([error.description containsString:@"cancelled"]) {
            [[HLLCache sharedHLLCache] cacheValue:@"cancel" key:NMDATA_KEY_STATE traceId:traceId];
        } else {
            [[HLLCache sharedHLLCache] cacheValue:@"failure" key:NMDATA_KEY_STATE traceId:traceId];
        }
    } else {
        switch (statusCode) {
            case 200:
            case 304:
                [[HLLCache sharedHLLCache] cacheValue:@"success" key:NMDATA_KEY_STATE traceId:traceId];
                break;
            default:
                [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%d", (int)statusCode] key:NMDATA_KEY_ERRORCODE traceId:traceId];
                [[HLLCache sharedHLLCache] cacheValue:@"2" key:NMDATA_KEY_ERRORTYPE traceId:traceId];
                [[HLLCache sharedHLLCache] cacheValue:@"failure" key:NMDATA_KEY_STATE traceId:traceId];
                break;
        }
    }
    [HLLObjectDelegate survayUpload:traceId];
    ress = [NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize +  bodySize + headerSize + [[[HLLCache sharedHLLCache] getNumByTraceId:traceId type:CacheDataTypeDownload] unsignedLongValue]];
    [[HLLCache sharedHLLCache] cacheValue:ress key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
    [[HLLCache sharedHLLCache] removeDataByTraceId:traceId];
    [[HLLCache sharedHLLCache] removeNumByTraceId:traceId type:CacheDataTypeDownload];
    if (httpResponse.MIMEType) {
        [[HLLCache sharedHLLCache] cacheValue:httpResponse.MIMEType key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    } else {
        NSString *type = task.originalRequest.URL.lastPathComponent.pathExtension;
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils mimeType:type] key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    }
    
    if (![HLLNetUtils isInterferenceMode]) {
        [[HLLCache sharedHLLCache] persistData:traceId];
    }
   
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = dataTask.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (traceId) {
        [[HLLCache sharedHLLCache] appendData:data byTraceId:traceId];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = downloadTask.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (traceId) {
        [HLLObjectDelegate survayDownload:traceId];
    }
   
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = downloadTask.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (traceId) {
        [[HLLCache sharedHLLCache] cacheNum:@(totalBytesWritten) byTraceId:traceId type:CacheDataTypeDownload];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
   
    if (completionHandler && ![self isKindOfClass:[HLLObjectDelegate class]]) {
        completionHandler(request);
    }
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    if (response) {
        NSString *traceId = task.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if (traceId) {
            NSString *host = request.URL.host;
            [[HLLCache sharedHLLCache] cacheValue:request.URL.absoluteString key:NMDATA_KEY_REDIRECTURL traceId:traceId];
            if ([HLLNetUtils isDomain:host]) {
                [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getIPByDomain:host] key:NMDATA_KEY_REDIRECTIP traceId:traceId];
            } else {
                [[HLLCache sharedHLLCache] cacheValue:host key:NMDATA_KEY_REDIRECTIP traceId:traceId];
            }
        }
    }
   
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = task.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    if (traceId) {
        [[HLLCache sharedHLLCache] cacheNum:@(totalBytesSent) byTraceId:traceId type:CacheDataTypeUpload];
    }
}

#pragma mark-NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    if (error) {
        [[HLLCache sharedHLLCache] cacheValue:@"failure" key:NMDATA_KEY_STATE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:@"1" key:NMDATA_KEY_ERRORTYPE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%d", (int)error.code] key:NMDATA_KEY_ERRORCODE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:error.description key:NMDATA_KEY_ERRORDETAIL traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)error.description.length] key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
        [HLLObjectDelegate survayUpload:traceId];
    }
    [HLLObjectDelegate survayDownload:traceId];
    
    if (![HLLNetUtils isInterferenceMode]) {
        [[HLLCache sharedHLLCache] persistData:traceId];
    }
   
}

- (nullable NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(nullable NSURLResponse *)response {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return nil;
    }
    if (response) {
        NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        [[HLLCache sharedHLLCache] cacheValue:request.URL.absoluteString key:NMDATA_KEY_REDIRECTURL traceId:traceId];
        if ([HLLNetUtils isDomain:request.URL.host]) {
            [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getIPByDomain:request.URL.host] key:NMDATA_KEY_REDIRECTIP traceId:traceId];
        } else {
            [[HLLCache sharedHLLCache] cacheValue:request.URL.host key:NMDATA_KEY_REDIRECTIP traceId:traceId];
        }
    }
   
    return request;
}

#pragma mark-NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    [[HLLCache sharedHLLCache] cacheValue:@"success" key:NMDATA_KEY_STATE traceId:traceId];
    if (httpResponse.MIMEType) {
        [[HLLCache sharedHLLCache] cacheValue:httpResponse.MIMEType key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    } else {
        NSString *type = connection.originalRequest.URL.lastPathComponent.pathExtension;
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils mimeType:type] key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    }
    NSUInteger statusLineSize = httpResponse.statusLineSize;
    NSUInteger headerSize = httpResponse.headerSize;
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize + headerSize];
    [[HLLCache sharedHLLCache] cacheValue:length key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
        return;
    }
    //记录接收到数据
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    [[HLLCache sharedHLLCache] appendData:data byTraceId:traceId];
}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
        return;
    }
    //缓存当前已上传数据大小
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    [[HLLCache sharedHLLCache] cacheNum:@(totalBytesWritten) byTraceId:traceId type:CacheDataTypeUpload];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    //停止时间
    [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    //响应监控
    NSUInteger length = [[[HLLCache sharedHLLCache] getDataByTraceId:traceId] gzippedData].length;
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)length] key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
    [[HLLCache sharedHLLCache] removeDataByTraceId:traceId];
    if (![HLLNetUtils isInterferenceMode]) {
        [[HLLCache sharedHLLCache] persistData:traceId];
    }
   
}

#pragma mark-NSURLConnectionDownloadDelegate
- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
        return;
    }
    //缓存当前已下载数据大小
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    [[HLLCache sharedHLLCache] cacheNum:@(totalBytesWritten) byTraceId:traceId type:CacheDataTypeDownload];
}

- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes {
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
        return;
    }
    //缓存当前已下载数据大小
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    [[HLLCache sharedHLLCache] cacheNum:@(totalBytesWritten) byTraceId:traceId type:CacheDataTypeDownload];
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL {
   
    if (![HLLNetUtils isHLLNetworkMonitorOn]) {
       
        return;
    }
    NSString *traceId = connection.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
    //停止时间
    [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    //下载数据统计
    [HLLObjectDelegate survayDownload:traceId];
    if (![HLLNetUtils isInterferenceMode]) {
        [[HLLCache sharedHLLCache] persistData:traceId];
    }
   
}

#pragma mark - util
+ (void)survayUpload:(NSString *)trId {
   
    if (!trId) {
       
        return;
    }
    NSNumber *uploadSize = [[HLLCache sharedHLLCache] getNumByTraceId:trId type:CacheDataTypeUpload];
    if (uploadSize != nil) {
        [[HLLCache sharedHLLCache] cacheValue:[uploadSize stringValue] key:NMDATA_KEY_REQUESTSIZE_BODY traceId:trId];
        [[HLLCache sharedHLLCache] removeNumByTraceId:trId type:CacheDataTypeUpload];
    }
   
}

+ (void)survayDownload:(NSString *)trId {
   
    if (!trId) {
       
        return;
    }
    NSNumber *downloadSize = [[HLLCache sharedHLLCache] getNumByTraceId:trId type:CacheDataTypeDownload];
    if (downloadSize != nil) {
        [[HLLCache sharedHLLCache] cacheValue:[downloadSize stringValue] key:NMDATA_KEY_RESPONSESIZE traceId:trId];
        [[HLLCache sharedHLLCache] removeNumByTraceId:trId type:CacheDataTypeDownload];
    }
   
}

@end
