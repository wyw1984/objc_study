//
//  NSURLConnectionDownloadDelegate.m
//  NetworkMonitorSample
//
//  Created by fengslon 2018/6/7.
//  Copyright © Copyright © 2020 Ssky. All rights reserved.
//

#import "NSURLConnectionDownloadDelegate.h"

@implementation NSURLConnectionDownloadDelegate

#pragma mark-NSURLConnectionDownloadDelegate
- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes {

}

- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes {

}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL {

}


@end
