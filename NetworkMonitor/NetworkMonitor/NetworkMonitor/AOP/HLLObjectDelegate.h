//
//  HLLObjectDelegate.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

//当应用层没有设置实现NSURLSessionDelegate或者NSURLConnectionDelegate的代理时，HLLNetworkMonitor会将本类的一个实例设置为代理，代理方法将被转发到本类的实现。

NS_ASSUME_NONNULL_BEGIN

@interface HLLObjectDelegate : NSObject<NSURLSessionDelegate, NSURLConnectionDelegate>

/**
 代理方法调用传递

 @param invocation 方法调用对象
 */
- (void)invoke:(NSInvocation *)invocation;

/**
 注册需要调用传递的方法

 @param selector 方法名
 */
- (void)registerSelector:(NSString *)selector;

/**
 注销需要调用传递的方法

 @param selector 方法名
 */
- (void)unregisterSelector:(NSString *)selector;



@end

NS_ASSUME_NONNULL_END
