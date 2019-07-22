//
//  SLProxy1.m
//  19.定时器
//
//  Created by fengsl on 2019/7/19.
//  Copyright © 2019 fengsl. All rights reserved.
//


//这个和SLProxy的区别就是，这个就是一步到位，不会到父类里面寻找，直接在当前类寻找，直接进入消息转发阶段

#import "SLProxy1.h"

@implementation SLProxy1

+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    SLProxy1 *proxy = [SLProxy1 alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}
@end
