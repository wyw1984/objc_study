//
//  NSURLConnection (NM)
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 NSURLConnection扩展，用于NSURLConnection相关方法的监控
 */
@interface NSURLConnection (Helper)

/**
 hook NSURLConnection 相关方法
 */
+ (void)hook;

/**
 取消hook NSURLConnection 相关方法
 */
//+ (void)unhook;


@end
