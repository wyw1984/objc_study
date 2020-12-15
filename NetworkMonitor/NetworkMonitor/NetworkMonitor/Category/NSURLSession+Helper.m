//
//  NSURLSession+Helper.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//


#import "NSURLSession+Helper.h"
//#import "HLLURLProtocol.h"
#import "HLLProxy.h"
#import "HLLObjectDelegate.h"
#import <objc/runtime.h>
#import "HLLCache.h"
#import "NSURL+Helper.h"
#import <UIKit/UIKit.h>
#import "NSHTTPURLResponse+Helper.h"
#import "NSURLRequest+Helper.h"

typedef void(^CompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);
typedef void(^DownloadCompletionHandler)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error);
typedef void(^UploadCompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@implementation NSURLSession (Helper)

#pragma mark method-hook
+ (void)hook {
    //初始化方法
    [HLLHooker hookClass:@"NSURLSession" sel:@"sessionWithConfiguration:delegate:delegateQueue:" withClass:@"NSURLSession" andSel:@"hook_sessionWithConfiguration:delegate:delegateQueue:"];
    //内部调用便捷式调用sessionWithConfiguration:delegate:delegateQueue:，不需要hook
//    [HLLHooker hookClass:@"NSURLSession" sel:@"sessionWithConfiguration:" withClass:@"NSURLSession" andSel:@"hook_sessionWithConfiguration:"];
    
    //网络请求
    //便捷式调用方法
    [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithRequest:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithRequest:completionHandler:"];
    //内部调用便捷式调用方法，不需要hook
    //iOS 13.0以上不再走便捷式方法，需要hook
    if (@available(iOS 13, *)) {
        [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithRequest:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithRequest:"];
        [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithURL:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithURL:"];
        [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithURL:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithURL:completionHandler:"];
    }
    
    //下载
    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithRequest:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithRequest:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithURL:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithURL:"];
    //    断点下载方法，暂不实现
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithResumeData:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithResumeData:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithRequest:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithRequest:completionHandler:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithURL:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithURL:completionHandler:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"downloadTaskWithResumeData:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_downloadTaskWithResumeData:completionHandler:"];
    
    //上传
    [HLLHooker hookInstance:@"NSURLSession" sel:@"uploadTaskWithRequest:fromFile:" withClass:@"NSURLSession" andSel:@"hook_uploadTaskWithRequest:fromFile:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"uploadTaskWithRequest:fromData:" withClass:@"NSURLSession" andSel:@"hook_uploadTaskWithRequest:fromData:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"uploadTaskWithStreamedRequest:" withClass:@"NSURLSession" andSel:@"hook_uploadTaskWithStreamedRequest:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"uploadTaskWithRequest:fromFile:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_uploadTaskWithRequest:fromFile:completionHandler:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"uploadTaskWithRequest:fromData:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_uploadTaskWithRequest:fromData:completionHandler:"];
}

/*
+ (void)unhook {
    //初始化方法
    [HLLHooker hookClass:@"NSURLSession" sel:@"hook_sessionWithConfiguration:delegate:delegateQueue:" withClass:@"NSURLSession" andSel:@"sessionWithConfiguration:delegate:delegateQueue:"];
    //    [HLLHooker hookClass:@"NSURLSession" sel:@"sessionWithConfiguration:" withClass:@"NSURLSession" andSel:@"hook_sessionWithConfiguration:"];
    
    //网络请求
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithRequest:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithRequest:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithURL:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithURL:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_dataTaskWithRequest:completionHandler:" withClass:@"NSURLSession" andSel:@"dataTaskWithRequest:completionHandler:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"dataTaskWithURL:completionHandler:" withClass:@"NSURLSession" andSel:@"hook_dataTaskWithURL:completionHandler:"];
    
    //下载
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithRequest:" withClass:@"NSURLSession" andSel:@"downloadTaskWithRequest:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithURL:" withClass:@"NSURLSession" andSel:@"downloadTaskWithURL:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithResumeData:" withClass:@"NSURLSession" andSel:@"downloadTaskWithResumeData:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithRequest:completionHandler:" withClass:@"NSURLSession" andSel:@"downloadTaskWithRequest:completionHandler:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithURL:completionHandler:" withClass:@"NSURLSession" andSel:@"downloadTaskWithURL:completionHandler:"];
    //    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_downloadTaskWithResumeData:completionHandler:" withClass:@"NSURLSession" andSel:@"downloadTaskWithResumeData:completionHandler:"];
    
    //上传
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_uploadTaskWithRequest:fromFile:" withClass:@"NSURLSession" andSel:@"uploadTaskWithRequest:fromFile:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_uploadTaskWithRequest:fromData:" withClass:@"NSURLSession" andSel:@"uploadTaskWithRequest:fromData:"];
//    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_uploadTaskWithStreamedRequest:" withClass:@"NSURLSession" andSel:@"uploadTaskWithStreamedRequest:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_uploadTaskWithRequest:fromFile:completionHandler:" withClass:@"NSURLSession" andSel:@"uploadTaskWithRequest:fromFile:completionHandler:"];
    [HLLHooker hookInstance:@"NSURLSession" sel:@"hook_uploadTaskWithRequest:fromData:completionHandler:" withClass:@"NSURLSession" andSel:@"uploadTaskWithRequest:fromData:completionHandler:"];
}
*/
#pragma mark hook_method
//初始化
+ (NSURLSession *)hook_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id <NSURLSessionDelegate>)delegate delegateQueue:(nullable NSOperationQueue *)queue {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //注册自定义NSURLProtocol
        //    NSMutableArray *array = [[configuration protocolClasses] mutableCopy];
        //    [array insertObject:[HLLURLProtocol class] atIndex:0];
        //    configuration.protocolClasses = array;
        
        HLLObjectDelegate *objectDelegate = [HLLObjectDelegate new];
        if (delegate) {
            [[self class] registerDelegateMethod:@"URLSession:task:didFinishCollectingMetrics:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@"];
            [[self class] registerDelegateMethod:@"URLSession:task:didCompleteWithError:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@"];
            [[self class] registerDelegateMethod:@"URLSession:dataTask:didReceiveData:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@"];
            
            [[self class] registerDelegateMethod:@"URLSession:downloadTask:didFinishDownloadingToURL:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@"];
            [[self class] registerDelegateMethod:@"URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@@@"];
            [[self class] registerDelegateMethod:@"URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@@@"];
            [[self class] registerDelegateMethod:@"URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@@@"];
            //        [[self class] registerDelegateMethod:@"URLSession:dataTask:didReceiveResponse:completionHandler:" oriDelegate:delegate assistDelegate:objectDelegate flag:"v@:@@@@"];
            
            delegate = [HLLProxy proxyForObject:delegate delegate:objectDelegate];
        } else {
            delegate = objectDelegate;
        }
    }
   
    return [self hook_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

//+ (NSURLSession *)hook_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration {
//    return [self hook_sessionWithConfiguration:configuration];
//}

//网络请求，调用dataTaskWithRequest:completionHandler:
- (NSURLSessionDataTask *)hook_dataTaskWithRequest:(NSURLRequest *)request {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_dataTaskWithRequest:request];
        }
        //请求相关监控
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
       
        return [self hook_dataTaskWithRequest:rq];
    }
   
    return [self hook_dataTaskWithRequest:request];
}

- (NSURLSessionDataTask *)hook_dataTaskWithURL:(NSURL *)url {
    if (!url) {
        EELog(@"url为空");
        return nil;
    }
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_dataTaskWithURL:url];
        }
        //请求相关监控
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
       
        return [self hook_dataTaskWithRequest:rq];
    }
   
    return [self hook_dataTaskWithURL:url];
}

- (NSURLSessionDataTask *)hook_dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    if (!url) {
        EELog(@"url为空");
        return nil;
    }
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_dataTaskWithURL:url completionHandler:completionHandler];
        }
        //请求相关监控
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
        if (completionHandler) {
            CompletionHandler hook_completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //把traceId设置到响应头
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                httpResponse.traceId = traceId;
               
                completionHandler(data, httpResponse, error);
                //响应监控
                [[self class] survayResponse:httpResponse traceId:traceId  requestUrl:request.URL.absoluteString data:data loaction:nil error:error];
                if (![HLLNetUtils isInterferenceMode]) {
                    [[HLLCache sharedHLLCache] persistData:traceId];
                }
            };
           
            return [self hook_dataTaskWithRequest:rq completionHandler:hook_completionHandler];
        }
       
        return [self hook_dataTaskWithRequest:rq completionHandler:completionHandler];
    }
   
    return [self hook_dataTaskWithURL:url completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)hook_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        //设置traceId，如果成功生成traceId，说明不在白名单中；
        //如果生成traceId为空，则说明在白名单中
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_dataTaskWithRequest:request completionHandler:completionHandler];
        }
        //请求相关监控
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
        
        if (completionHandler) {
            CompletionHandler hook_completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //把traceId设置到响应头
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                httpResponse.traceId = traceId;
               
                completionHandler(data, httpResponse, error);
                //响应监控
                [[self class] survayResponse:httpResponse traceId:traceId  requestUrl:request.URL.absoluteString data:data loaction:nil error:error];
                if (![HLLNetUtils isInterferenceMode]) {
                    [[HLLCache sharedHLLCache] persistData:traceId];
                }
            };
           
            return [self hook_dataTaskWithRequest:rq completionHandler:hook_completionHandler];
        }
       
        return [self hook_dataTaskWithRequest:rq completionHandler:completionHandler];
    }
   
    return [self hook_dataTaskWithRequest:request completionHandler:completionHandler];
}

//下载
- (NSURLSessionDownloadTask *)hook_downloadTaskWithRequest:(NSURLRequest *)request {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
            [[self class] survayRequest:rq traceId:traceId];
           
            return [self hook_downloadTaskWithRequest:rq];
        }
    }
   
    return [self hook_downloadTaskWithRequest:request];
}

- (NSURLSessionDownloadTask *)hook_downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_downloadTaskWithRequest:request completionHandler:completionHandler];
        }
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
        if (completionHandler) {
            DownloadCompletionHandler hook_completionHandler = ^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                httpResponse.traceId = traceId;
               
                completionHandler(location, httpResponse, error);
                //响应监控
                [[self class] survayResponse:httpResponse traceId:traceId  requestUrl:request.URL.absoluteString data:nil loaction:[location.absoluteString lastPathComponent] error:error];

                if (![HLLNetUtils isInterferenceMode]) {
                    [[HLLCache sharedHLLCache] persistData:traceId];
                }
            };
           
            return [self hook_downloadTaskWithRequest:rq completionHandler:hook_completionHandler];
        }
       
        return [self hook_downloadTaskWithRequest:rq completionHandler:completionHandler];
    }
   
    return [self hook_downloadTaskWithRequest:request completionHandler:completionHandler];
}

//- (NSURLSessionDownloadTask *)hook_downloadTaskWithURL:(NSURL *)url {
//    return [self hook_downloadTaskWithURL:url];
//}

//- (NSURLSessionDownloadTask *)hook_downloadTaskWithResumeData:(NSData *)resumeData {
//    return [self hook_downloadTaskWithResumeData:resumeData];
//}

//- (NSURLSessionDownloadTask *)hook_downloadTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
//    return [self hook_downloadTaskWithURL:url completionHandler:completionHandler];
//}

//- (NSURLSessionDownloadTask *)hook_downloadTaskWithResumeData:(NSData *)resumeData completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
//    return [self hook_downloadTaskWithResumeData:resumeData completionHandler:completionHandler];
//}

//上传
- (NSURLSessionUploadTask *)hook_uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
            [[self class] survayRequest:rq traceId:traceId];
           
            return [self hook_uploadTaskWithRequest:rq fromFile:fileURL];
        }
    }
   
    return [self hook_uploadTaskWithRequest:request fromFile:fileURL];
}

- (NSURLSessionUploadTask *)hook_uploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
            [[self class] survayRequest:rq traceId:traceId];
           
            return [self hook_uploadTaskWithRequest:rq fromData:bodyData];
        }
    }
   
    return [self hook_uploadTaskWithRequest:request fromData:bodyData];
}

- (NSURLSessionUploadTask *)hook_uploadTaskWithStreamedRequest:(NSURLRequest *)request {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (traceId) {
            NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
            [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
            [[self class] survayRequest:rq traceId:traceId];
           
            return [self hook_uploadTaskWithStreamedRequest:rq];
        }
    }
   
    return [self hook_uploadTaskWithStreamedRequest:request];
}

- (NSURLSessionUploadTask *)hook_uploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_uploadTaskWithRequest:request fromFile:fileURL completionHandler:completionHandler];
        }
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
        
        if (completionHandler) {
            UploadCompletionHandler hook_completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //把traceId设置到响应头
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                httpResponse.traceId = traceId;
               
                completionHandler(data, httpResponse, error);
                //响应监控
                [[self class] survayResponse:httpResponse traceId:traceId requestUrl:request.URL.absoluteString data:data loaction:nil error:error];
                [[self class] survayUpload:traceId];
                if (![HLLNetUtils isInterferenceMode]) {
                    [[HLLCache sharedHLLCache] persistData:traceId];
                }
            };
           
            return [self hook_uploadTaskWithRequest:rq fromFile:fileURL completionHandler:hook_completionHandler];
        }
       
        return [self hook_uploadTaskWithRequest:rq fromFile:fileURL completionHandler:completionHandler];
    }
   
    return [self hook_uploadTaskWithRequest:request fromFile:fileURL completionHandler:completionHandler];
}

- (NSURLSessionUploadTask *)hook_uploadTaskWithRequest:(NSURLRequest *)request fromData:(nullable NSData *)bodyData completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
   
    if ([HLLNetUtils isHLLNetworkMonitorOn]) {
        NSString *traceId = [[self class] isInWhiteLists:request];
        if (!traceId) {
           
            return [self hook_uploadTaskWithRequest:request fromData:bodyData completionHandler:completionHandler];
        }
        NSMutableURLRequest *rq = [HLLNetUtils mutableRequest:request];
        [rq setValue:traceId forHTTPHeaderField:HEAD_KEY_EETRACEID];
        [[self class] survayRequest:rq traceId:traceId];
        
        if (completionHandler) {
            UploadCompletionHandler hook_completionHandler = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                //把traceId设置到响应头
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                httpResponse.traceId = traceId;
               
                completionHandler(data, httpResponse, error);
                //响应监控
                [[self class] survayResponse:httpResponse traceId:traceId requestUrl:request.URL.absoluteString data:data loaction:nil error:error];
                [[self class] survayUpload:traceId];
                if (![HLLNetUtils isInterferenceMode]) {
                    [[HLLCache sharedHLLCache] persistData:traceId];
                }
            };
           
            return [self hook_uploadTaskWithRequest:rq fromData:bodyData completionHandler:hook_completionHandler];
        }
       
        return [self hook_uploadTaskWithRequest:rq fromData:bodyData completionHandler:completionHandler];
    }
   
    return [self hook_uploadTaskWithRequest:request fromData:bodyData completionHandler:completionHandler];
}

#pragma mark util
//响应相关监控
+ (void)survayResponse:(NSHTTPURLResponse *)httpResponse traceId:(NSString *)traceId requestUrl:(NSString *)requestUrl data:(NSData *)data loaction:(NSString *)location error:(NSError *)error {
   
    //低于10.0版本适配
    if (![HLLNetUtils isAbove_iOS_10_0]) {
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_ENDRESPONSE traceId:traceId];
    }
    //响应相关监控
    NSInteger statusCode = httpResponse.statusCode;
    NSUInteger statusLineSize = httpResponse.statusLineSize;
    NSUInteger headerSize = httpResponse.headerSize;
    if ([[httpResponse.allHeaderFields objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
        // 模拟压缩
        data = [data gzippedData];
    }
    NSUInteger bodySize = data.length;
    NSString *ress;
    if (error) {
        [[HLLCache sharedHLLCache] cacheValue:@"1" key:NMDATA_KEY_ERRORTYPE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%d", (int)error.code] key:NMDATA_KEY_ERRORCODE traceId:traceId];
        [[HLLCache sharedHLLCache] cacheValue:error.description key:NMDATA_KEY_ERRORDETAIL traceId:traceId];
        if ([error.description containsString:@"cancelled"]) {
            [[HLLCache sharedHLLCache] cacheValue:@"cancel" key:NMDATA_KEY_STATE traceId:traceId];
        } else {
            [[HLLCache sharedHLLCache] cacheValue:@"failure" key:NMDATA_KEY_STATE traceId:traceId];
        }
//        ress = [NSString stringWithFormat:@"%lu", (unsigned long)error.description.length + data.length];
        ress = [NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize + headerSize + bodySize];
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
        if (location) {
            NSNumber *fileSize = [HLLNetUtils sizeOfItemAtPath:[NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), location] error:nil];
//            ress = [NSString stringWithFormat:@"%lu", (unsigned long)httpResponse.description.length + fileSize.unsignedLongValue];
            ress = [NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize + headerSize + bodySize + [fileSize unsignedLongValue]];
        } else {
//            ress = [NSString stringWithFormat:@"%lu", (unsigned long)httpResponse.description.length + data.length];
            ress = [NSString stringWithFormat:@"%lu", (unsigned long)statusLineSize + headerSize + bodySize];
        }
    }
    [[HLLCache sharedHLLCache] cacheValue:ress key:NMDATA_KEY_RESPONSESIZE traceId:traceId];
//    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (long)statusCode] key:NMDATA_KEY_STATUSCODE traceId:traceId];
    if (httpResponse.MIMEType) {
        [[HLLCache sharedHLLCache] cacheValue:httpResponse.MIMEType key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    } else {
        NSString *type = requestUrl.lastPathComponent.pathExtension;
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils mimeType:type] key:NMDATA_KEY_CONTENTTYPE traceId:traceId];
    }
   
}

//请求相关监控
+ (void)survayRequest:(NSMutableURLRequest *)rq traceId:(NSString *)traceId {
   
    if (![HLLNetUtils isAbove_iOS_10_0]) {
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getCurrentTime] key:NMDATA_KEY_STARTREQUEST traceId:traceId];
    }
    NSString *host = rq.URL.host;
    [[HLLCache sharedHLLCache] cacheValue:rq.URL.absoluteString key:NMDATA_KEY_ORIGINALURL traceId:traceId];
    if ([HLLNetUtils isDomain:host]) {
        [[HLLCache sharedHLLCache] cacheValue:[HLLNetUtils getIPByDomain:host] key:NMDATA_KEY_ORIGINALIP traceId:traceId];
    } else {
        [[HLLCache sharedHLLCache] cacheValue:host key:NMDATA_KEY_ORIGINALIP traceId:traceId];
    }
    NSUInteger statusLineSize = rq.statusLineSize;
    NSUInteger headerSize = rq.headerSize;
    NSUInteger bodySize = rq.bodySize;
    NSUInteger length = statusLineSize + headerSize;
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)length] key:NMDATA_KEY_REQUESTSIZE_HEAD traceId:traceId];
    [[HLLCache sharedHLLCache] cacheValue:[NSString stringWithFormat:@"%lu", (unsigned long)bodySize] key:NMDATA_KEY_REQUESTSIZE_BODY traceId:traceId];
   
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

+ (NSString *)isInWhiteLists:(NSURLRequest *)request {
   
    for (NSString *url in [HLLNetworkMonitorManager sharedNetworkMonitorManager].getConfig.urlWhiteList) {
        if ([request.URL.absoluteString containsString:url]) {
           
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


//代理方法分类处理
+ (void)registerDelegateMethod:(NSString *)method oriDelegate:(id<NSURLSessionDelegate>)oriDel assistDelegate:(HLLObjectDelegate *)assiDel flag:(const char *)flag {
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


@end
