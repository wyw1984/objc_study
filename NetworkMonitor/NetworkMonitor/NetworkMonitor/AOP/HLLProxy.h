//
//  HLLProxy.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLLObjectDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface HLLProxy : NSProxy

/**
 注册对象代理

 @param obj 需要注册的代理
 @param delegate 代理方法
 @return 返回包裹了代理监控的代理对象
 */
+ (id)proxyForObject:(id)obj delegate:(HLLObjectDelegate *)delegate;

@end

NS_ASSUME_NONNULL_END
