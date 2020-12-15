//
//  NSURLConnection (NM)
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//


#import "NSURLConnection+Helper.h"
#import "HLLProxy.h"
#import <objc/runtime.h>
#import "HLLObjectDelegate.h"
#import "HLLCache.h"
#import "NSURL+Helper.h"
#import "NSHTTPURLResponse+Helper.h"
#import "NSURLRequest+Helper.h"

typedef void (^CompletionHandler)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError);

@implementation NSURLConnection (Helper)

#pragma mark method-hook
+ (void)hook {
    //同步请求
    [HLLHooker hookClass:@"NSURLConnection" sel:@"sendSynchronousRequest:returningResponse:error:" withClass:@"NSURLConnection" andSel:@"hook_sendSynchronousRequest:returningResponse:error:"];
    //异步请求
    [HLLHooker hookClass:@"NSURLConnection" sel:@"sendAsynchronousRequest:queue:completionHandler:" withClass:@"NSURLConnection" andSel:@"hook_sendAsynchronousRequest:queue:completionHandler:"];
    //初始化方法
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"initWithRequest:delegate:startImmediately:" withClass:@"NSURLConnection" andSel:@"hook_initWithRequest:delegate:startImmediately:"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"initWithRequest:delegate:" withClass:@"NSURLConnection" andSel:@"hook_initWithRequest:delegate:"];
//    [HLLHooker hookClass:@"NSURLConnection" sel:@"connectionWithRequest:delegate:" withClass:@"NSURLConnection" andSel:@"hook_connectionWithRequest:delegate:"];
    //代理模式开始与取消
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"start" withClass:@"NSURLConnection" andSel:@"hook_start"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"cancel" withClass:@"NSURLConnection" andSel:@"hook_cancel"];
}

/*
+ (void)unhook {
    [HLLHooker hookClass:@"NSURLConnection" sel:@"hook_sendSynchronousRequest:returningResponse:error:" withClass:@"NSURLConnection" andSel:@"sendSynchronousRequest:returningResponse:error:"];
    [HLLHooker hookClass:@"NSURLConnection" sel:@"hook_sendAsynchronousRequest:queue:completionHandler:" withClass:@"NSURLConnection" andSel:@"sendAsynchronousRequest:queue:completionHandler:"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"hook_initWithRequest:delegate:startImmediately:" withClass:@"NSURLConnection" andSel:@"initWithRequest:delegate:startImmediately:"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"hook_initWithRequest:delegate:" withClass:@"NSURLConnection" andSel:@"initWithRequest:delegate:"];
    //    [HLLHooker hookClass:@"NSURLConnection" sel:@"connectionWithRequest:delegate:" withClass:@"NSURLConnection" andSel:@"hook_connectionWithRequest:delegate:"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"hook_start" withClass:@"NSURLConnection" andSel:@"start"];
    [HLLHooker hookInstance:@"NSURLConnection" sel:@"hook_cancel" withClass:@"NSURLConnection" andSel:@"cancel"];
}
*/

#pragma mark hooked method
//异步请求方法
+ (void)hook_sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*)queue completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError)) handler {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            [[self class] hook_sendAsynchronousRequest:request queue:queue completionHandler:handler];
            return;
        }
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        //请求相关监控
        [[self class] survayRequest:rq traceId:traceId];
        CompletionHandler hook_handler = ^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            //响应相关监控
            [[self class] survayResponse:httpResponse traceId:traceId requestUrl:request.URL.absoluteString data:data error:connectionError];
            httpResponse.traceId = traceId;
            if (handler) {
               
                handler(httpResponse, data, connectionError);
            }
            //如果是上传，需要统计已上传数据
            if (connectionError) {
                [[self class] survayUpload:traceId];
            }
            if (![HLLNetUtils isInterferenceMode]) {
                [[HLLCache sharedHLLCache] persistData:traceId];
            }
        };
       
        [[self class] hook_sendAsynchronousRequest:rq queue:queue completionHandler:hook_handler];
        return;
    }
   
    [[self class] hook_sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

//同步请求方法
+ (nullable NSData *)hook_sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [[self class] hook_sendSynchronousRequest:request returningResponse:response error:error];
        }
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        //请求相关监控
        [[self class] survayRequest:rq traceId:traceId];
        //发起请求
        NSData *data = [[self class] hook_sendSynchronousRequest:rq returningResponse:response error:error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)(*response);
        //响应相关监控
        [[self class] survayResponse:httpResponse traceId:traceId requestUrl:request.URL.absoluteString data:data error:*error];
        httpResponse.traceId = traceId;
        *response = httpResponse;
        
        //如果是上传，需要统计已上传数据
        if (error) {
            [[self class] survayUpload:traceId];
        }
        if (![HLLNetUtils isInterferenceMode]) {
            [[HLLCache sharedHLLCache] persistData:traceId];
        }
       
        return data;
    }
   
    return [[self class] hook_sendSynchronousRequest:request returningResponse:response error:error];
}

//初始化方法一
- (nullable instancetype)hook_initWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate startImmediately:(BOOL)startImmediately {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
           
            return [self hook_initWithRequest:rq delegate:[self processDelegate:delegate] startImmediately:startImmediately];
        }
    }
   
    return [self hook_initWithRequest:request delegate:delegate startImmediately:startImmediately];
}

//初始化方法二
- (nullable instancetype)hook_initWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
           
            return [self hook_initWithRequest:rq delegate:[self processDelegate:delegate]];
        }
    }
   
    return [self hook_initWithRequest:request delegate:delegate];
}

//初始化方法三
//+ (nullable NSURLConnection*)hook_connectionWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate {
//    NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
//    [rq setValue:[HLLNetUtils getTraceId] forHTTPHeaderField:HEAD_KEY_EETRACEID];
//    return [[self class] hook_connectionWithRequest:rq delegate:delegate];
//}

//请求开始
- (void)hook_start {
    [self hook_start];
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = self.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if (traceId) {
            [[self class] survayRequest:self.originalRequest traceId:traceId];
        }
    }
   
}

//请求取消
- (void)hook_cancel {
    [self hook_cancel];
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = self.originalRequest.allHTTPHeaderFields[HEAD_KEY_EETRACEID];
        if (traceId) {
            //结束时间
            [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
            [[HLLCache sharedHLLCache] cacheValue:@"cancel" key:NMDATA_KEY_STATE traceId:traceId];
            [[self class] survayDownload:traceId];
            [[self class] survayUpload:traceId];
            if (![HLLNetUtils isInterferenceMode]) {
                [[HLLCache sharedHLLCache] persistData:traceId];
            }
        }
    }
   
}

#pragma mark util
//请求相关监控
+ (void)survayResponse:(NSHTTPURLResponse *)httpResponse traceId:(NSString *)traceId requestUrl:(NSString *)requestUrl data:(NSData *)data error:(NSError *)error {
   
    //结束时间
    [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    NSUInteger statusLineSize = httpResponse.statusLineSize;
    NSUInteger headerSize = httpResponse.headerSize;
    if ([[httpResponse.allHeaderFields objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
        // 模拟压缩
        data = [data gzippedData];
    }
    
    NSUInteger bodySize = data.length;
    //响应相关监控
    NSInteger statusCode = httpResponse.statusCode;
    if (error) {
        [[HLLCache sharedHLLCache] cacheValue:@"failure" key:NMDATA_KEY_STATE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:@"1" key:NMDATA_KEY_ERRORTYPE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%d", (int)error.code] key:NMDATA_KEY_ERRORCODE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:error.description key:NMDATA_KEY_ERRORDETAIL traceId:traceId];
//        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)error.description.length + data.length] key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
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
//        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)httpResponse.description.length + data.length] key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
    }
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize + headerSize +bodySize] key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
//    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (long)statusCode] key:NMDATA_KEY_STATUSCODE traceId:traceId];
    if (httpResponse.MIMEType) {
        [[HLLCache sharedHLLCache] cacheValue:httpResponse.MIMEType key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    } else {
        NSString *type = requestUrl.lastPathComponent.pathExtension;
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils mimeType:type] key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    }
    //重定向url
    if (![httpResponse.URL.absoluteString isEqualToString:requestUrl]) {
        [[HLLCache sharedHLLCache] cacheValue:httpResponse.URL.absoluteString key:NMDATA_KEY_REDIRECTURL traceId:traceId];
        if ([HLLNetUtils isDomain:httpResponse.URL.host]) {
            [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getIPByDomain:httpResponse.URL.host] key:NMDATA_KEY_REDIRECTIP traceId:traceId];
        } else {
            [[HLLCache sharedHLLCache] cacheValue:httpResponse.URL.host key:NMDATA_KEY_REDIRECTIP traceId:traceId];
        }
    }
   
}

+ (void)survayRequest:(NSURLRequest *)req traceId:(NSString *)trId {
   
    //开始时间
    [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_STARTREQUEST traceId:trId];
    NSString *host = req.URL.host;
    [[HLLCache sharedHLLCache] cacheValue:req.URL.absoluteString key:NMDATA_KEY_ORIGINALURL traceId:trId];
    if ([HLLNetUtils isDomain:host]) {
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getIPByDomain:host] key:NMDATA_KEY_ORIGINALIP traceId:trId];
    } else {
        [[HLLCache sharedHLLCache] cacheValue:host key:NMDATA_KEY_ORIGINALIP traceId:trId];
    }
//    NSUInteger lenght = req.HTTPBody.length + req.URL.absoluteString.length + req.allHTTPHeaderFields.description.length;
    
    NSUInteger statusLineSize = req.statusLineSize;
    NSUInteger headerSize = req.headerSize;
    NSUInteger bodySize = req.bodySize;
    NSUInteger length = statusLineSize + headerSize;
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)length] key:NMDATA_KEY_REQUESTSIZE_HEAD traceId:trId];
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodySize] key:NMDATA_KEY_REQUESTSIZE_BODY traceId:trId];
   
}

+ (NSString *)isInWhiteLists:(NSURLRequest *)request {
   
    for (NSString *urlStr in [HLLNetworkMonitorManager sharedNetworkMonitorManager].getConfig.urlWhiteList) {
        if ([request.URL.absoluteString containsString:urlStr]) {
           
            return nil;
        }
    }
    NSDictionary *extension = request.URL.extendedParameter;
    if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager].getConfig.cmdWhiteList containsObject:extension[NMDATA_KEY_CMD]]) {
       
        return nil;
    }
    NSDictionary *extensionInHeader = [HLLNetUtils extractParamsFromHeader:request.allHTTPHeaderFields];
    if ([[HLLNetworkMonitorManager sharedNetworkMonitorManager].getConfig.cmdWhiteList containsObject:extensionInHeader[NMDATA_KEY_CMD]]) {
       
        return nil;
    }
    NSString *trId = [HLLNetUtils getTraceId];
    if (extension) {
        [[HLLCache sharedHLLCache] cacheExtension:extension traceId:trId];
    }
    
    if (extensionInHeader && extensionInHeader.count > 0) {
        [[HLLCache sharedHLLCache] cacheExtension:extensionInHeader traceId:trId];
    }
   
    return trId;
}

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

- (id)processDelegate:(id)delegate {
    HLLObjectDelegate *objectDelegate = [HLLObjectDelegate new];
    if (delegate) {
        //以下为请求代理方法
        [self registerDelegateMethod:@"connection:didFailWithError:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@"];
        [self registerDelegateMethod:@"connection:didReceiveResponse:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@"];
        [self registerDelegateMethod:@"connection:didReceiveData:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@"];
        [self registerDelegateMethod:@"connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@@"];
        [self registerDelegateMethod:@"connectionDidFinishLoading:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@"];
        [self registerDelegateMethod:@"connection:willSendRequest:redirectResponse:" oriDelegate:delegate assistDelegate:objectDelegate flag:"@@:@@"];
        
        //以下为下载代理方法
        [self registerDownloadDelegateMethod:@"connection:didWriteData:totalBytesWritten:expectedTotalBytes:" oriDelegate:delegate assistDelegate:objectDelegate ];
        [self registerDownloadDelegateMethod:@"connectionDidResumeDownloading:totalBytesWritten:expectedTotalBytes:" oriDelegate:delegate assistDelegate:objectDelegate];
        [self registerDownloadDelegateMethod:@"connectionDidFinishDownloading:destinationURL:" oriDelegate:delegate assistDelegate:objectDelegate];
        
        delegate = [HLLProxy proxyForObject:delegate delegate:objectDelegate];
    } else {
        delegate = objectDelegate;
    }
    return delegate;
}


//对代理方法分类处理
- (void)registerDelegateMethod:(NSString *)method oriDelegate:(id)oriDel assistDelegate:(HLLObjectDelegate *)assiDel flag:(const char *)flag {
    if ([oriDel respondsToSelector:NSSelectorFromString(method)]) {
        IMP imp1 = class_getMethodImplementation([HLLObjectDelegate class], NSSelectorFromString(method));
        IMP imp2 = class_getMethodImplementation([oriDel class], NSSelectorFromString(method));
        if (imp1 != imp2) {
            [assiDel registerSelector:method];
        }
    } else {
        class_addMethod([oriDel class], NSSelectorFromString(method), class_getMethodImplementation([HLLObjectDelegate class], NSSelectorFromString(method)), flag);
    }
}

//对下载代理方法处理
//下载代理方法比较特殊，如果应用不实现下载代理方法，
//则不走下载代理方法，而会走普通请求代理方法
- (void)registerDownloadDelegateMethod:(NSString *)method oriDelegate:(id)oriDel assistDelegate:(HLLObjectDelegate *)assiDel {
    if ([oriDel respondsToSelector:NSSelectorFromString(method)]) {
        [assiDel registerSelector:method];
    }
}



@end
