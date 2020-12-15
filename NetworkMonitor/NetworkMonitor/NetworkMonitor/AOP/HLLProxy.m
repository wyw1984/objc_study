//
//  HLLProxy.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLProxy.h"
#import "HLLObjectDelegate.h"

@interface HLLProxy() {
    id _object; //代理对象
    HLLObjectDelegate *_objectDelegate; //代理方法调用传递对象
}


@end

@implementation HLLProxy




+ (id)proxyForObject:(id)obj delegate:(HLLObjectDelegate *)delegate {
    HLLProxy *instance = [HLLProxy alloc];
    instance->_object = obj;
    instance->_objectDelegate = delegate;
    
    return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_object respondsToSelector:invocation.selector]) {
        //代理方法执行
        [invocation invokeWithTarget:_object];
        //代理方法执行传递
        [_objectDelegate invoke:invocation];
    }
}

@end
