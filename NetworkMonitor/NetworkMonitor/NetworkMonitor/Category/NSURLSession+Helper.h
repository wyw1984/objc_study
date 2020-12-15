//
//  NSURLSession+Helper.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 NSURLSession扩展，用于NSURLSession相关方法的监控
 */
@interface NSURLSession (Helper)

/**
 hook NSURLSession 相关方法
 */
+ (void)hook;

/**
 取消hook NSURLSession 相关方法
 */
//+ (void)unhook;


@end
