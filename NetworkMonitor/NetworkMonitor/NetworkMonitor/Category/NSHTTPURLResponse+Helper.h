//
//  NSHTTPURLResponse+Helper.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 为响应头添加traceId
 */
@interface NSHTTPURLResponse (Helper)

/**
 在响应头中添加traceId
 */
@property (nonatomic, strong) NSString *traceId;

@property (nonatomic, assign, readonly) NSUInteger statusLineSize;

@property (nonatomic, assign, readonly) NSUInteger headerSize;

@end
