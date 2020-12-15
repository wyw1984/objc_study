//
//  HLLURLProtocol.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLURLProtocol.h"

@implementation HLLURLProtocol

+ (void)load {
//    [NSURLProtocol registerClass:[self class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSURL *url = [request URL];
    EELog(@"%@", url);
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (void)startLoading {
    NSLog(@"startLoading");
}

- (void)stopLoading {
    NSLog(@"stopLoading");
}

//- (void)responseData:(NSData *)data withHeaders:(NSMutableDictionary *)headers {
//    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headers];
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    [[self client] URLProtocol:self didLoadData:data];
//    [[self client] URLProtocolDidFinishLoading:self];
//}
//
//- (void)response404 {
//    NSMutableDictionary* headers = [[NSMutableDictionary alloc] init];
//    headers[@"Cache-Control"] = @"no-cache";
//    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[[self request] URL] statusCode:404 HTTPVersion:@"HTTP/1.1" headerFields:headers];
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    [[self client] URLProtocolDidFinishLoading:self];
//}


- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}




@end
