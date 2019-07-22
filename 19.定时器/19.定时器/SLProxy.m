//
//  SLProxy.m
//  19.定时器
//
//  Created by fengsl on 2019/7/19.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "SLProxy.h"

@implementation SLProxy

+ (instancetype)proxyWithTarget:(id)target
{
    SLProxy *proxy = [[SLProxy alloc]init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}



@end
