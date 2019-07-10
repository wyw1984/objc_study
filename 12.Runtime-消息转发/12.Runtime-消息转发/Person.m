//
//  Person.m
//  12.Runtime-消息转发
//
//  Created by fengsl on 2019/6/16.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Car.h"

@implementation Person

struct method_t{
    SEL sel;
    char *types;
    IMP imp;
};

//+(BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(eat:)) {
//        class_addMethod(self, sel, (IMP)cook, "v@:@");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
void cook(id self ,SEL _cmd,id Num)
{
    // 实现内容
    NSLog(@"%@的%@方法动态实现了,参数为%@",self,NSStringFromSelector(_cmd),Num);
}


- (void)other{
    NSLog(@"%s",__func__);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    // 动态的添加方法实现
    if (sel == @selector(test)) {
        
        // Method强转为method_t
        struct method_t *method = (struct method_t *)class_getInstanceMethod(self, @selector(other));
        
        NSLog(@"%s,%p,%s",method->sel,method->imp,method->types);
        
        // 动态添加test方法的实现
        class_addMethod(self, sel, method->imp, method->types);
        
        // 返回YES表示有动态添加方法
        return YES;
//
//        //####################系统实现#######################
//        // 获取其他方法 指向method_t的指针
//        Method otherMethod = class_getInstanceMethod(self, @selector(other));
//
//        // 动态添加test方法的实现
//        class_addMethod(self, sel, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod));
//
//        // 返回YES表示有动态添加方法
//        return YES;
    }
    
    NSLog(@"%s", __func__);
    return [super resolveInstanceMethod:sel];
}
void otherClass(id self, SEL _cmd)
{
    NSLog(@"other - %@ - %@", self, NSStringFromSelector(_cmd));
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(testClass)) {
        // 第一个参数是object_getClass(self)，传入元类对象。
        class_addMethod(object_getClass(self), sel, (IMP)otherClass, "v16@0:8");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    //返回能够处理消息的对象
//    if (aSelector == @selector(driving)) {
//        return [[Car alloc]init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    //返回能够处理消息的对象
    if (aSelector == @selector(driving)) {
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}


//方法签名：返回值类型，参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(driving)) {
        // return [NSMethodSignature signatureWithObjCTypes: "v@:"];
        // return [NSMethodSignature signatureWithObjCTypes: "v16@0:8"];
        // 也可以通过调用Car的methodSignatureForSelector方法得到方法签名，这种方式需要car对象有aSelector方法
        return [[[Car alloc]init] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}
//NSInvocation 封装了一个方法调用，包括：方法调用者，方法，方法的参数
//    anInvocation.target 方法调用者
//    anInvocation.selector 方法名
//    [anInvocation getArgument: NULL atIndex: 0]; 获得参数
- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    anInvocation中封装了methodSignatureForSelector函数中返回的方法。
    //   此时anInvocation.target 还是person对象，我们需要修改target为可以执行方法的方法调用者。
    //   anInvocation.target = [[Car alloc] init];
    //   [anInvocation invoke];
    [anInvocation invokeWithTarget: [[Car alloc] init]];
    
}
@end
