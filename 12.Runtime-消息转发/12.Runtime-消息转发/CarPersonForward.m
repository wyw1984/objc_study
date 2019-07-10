//
//  CarPersonForward.m
//  12.Runtime-消息转发
//
//  Created by fengsl on 2019/6/16.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "CarPersonForward.h"
#import "CarForward.h"


@implementation CarPersonForward

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    //返回呢能够处理消息的对象
    if (aSelector == @selector(driving)) {
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}

//方法签名：返回值类型，参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if (aSelector == @selector(driving:)) {
        //添加一个int参数及int返回值type为i@:i
        return [NSMethodSignature signatureWithObjCTypes:"i@:i"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//NSInvocation 封装了一个方法调用，包括：方法调用者，方法f，方法的参数
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    int time;
    // 获取方法的参数，方法默认还有self和cmd两个参数，因此新添加的参数下标为2
    [anInvocation getArgument: &time atIndex: 2];
    NSLog(@"修改前参数的值 = %d",time);
    time = time + 10; // time = 110
    NSLog(@"修改前参数的值 = %d",time);
    // 设置方法的参数 此时将参数设置为110
    [anInvocation setArgument: &time atIndex:2];
    // 将tagert设置为Car实例对象
    [anInvocation invokeWithTarget: [[CarForward alloc] init]];
    // 获取方法的返回值
    int result;
    [anInvocation getReturnValue: &result];
    NSLog(@"获取方法的返回值 = %d",result); // result = 220,说明参数修改成功
    result = 99;
    // 设置方法的返回值 重新将返回值设置为99
    [anInvocation setReturnValue: &result];
    // 获取方法的返回值
    [anInvocation getReturnValue: &result];
    NSLog(@"修改方法的返回值为 = %d",result);    // result = 99
}

@end
