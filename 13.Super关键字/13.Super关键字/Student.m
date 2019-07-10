//
//  Student.m
//  13.Super关键字
//
//  Created by fengsl on 2019/7/9.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Student.h"

@implementation Student

/*
 [super message]的底层实现
 1.消息接收者仍然是子类对象
 2.从父类开始查找方法的实现
 */

struct objc_super {
    __unsafe_unretained _Nonnull id receiver; // 消息接收者
    __unsafe_unretained _Nonnull Class super_class; // 消息接收者的父类
};

- (void)run
{
    // super调用的receiver仍然是Student对象
    [super run];
    
//    (id)class_getSuperclass(objc_getClass("Student")) //Person
//    ((void (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Student"))}, sel_registerName("run"));
    
    
    //    struct objc_super arg = {self, [Person class]};
    //
    //    objc_msgSendSuper(arg, @selector(run));
    //
    //
    //    NSLog(@"Studet.......");
    
}

- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"[self class] = %@", [self class]); // Student
        NSLog(@"[self superclass] = %@", [self superclass]); // Person
        
        NSLog(@"--------------------------------");
        
        // objc_msgSendSuper({self, [Person class]}, @selector(class));
        NSLog(@"[super class] = %@", [super class]); // Student
        NSLog(@"[super superclass] = %@", [super superclass]); // Person
    }
    return self;
}

@end
