//
//  main.m
//  15.Runtime应用
//
//  Created by fengsl on 2019/7/11.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Student.h"
#import "Person.h"
#import "Car.h"
#import "NSObject+Json.h"

void testSetClass()
{
    Person *person = [[Person alloc]init];
    [person run];
    
    //设置class isa指向
    object_setClass(person, [Car class]);
    [person run];
}

void testGetClass(){
     Person *person = [[Person alloc]init];
    NSLog(@"%d %d %d",
          object_isClass(person),
          object_isClass([Person class]),
          object_isClass(object_getClass([Person class]))
          );
}
void run(id self,SEL _cmd)
{
    NSLog(@"-----%@ - %@",self,NSStringFromSelector(_cmd));
}

void testClass1(){
    //创建类
    Class newClass = objc_allocateClassPair([NSObject class], "Dog", 0);
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_weight", 4, 1, @encode(int));
    class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
    //注册类
    objc_registerClassPair(newClass);
    
    id dog = [[newClass alloc]init];
    [dog setValue:@10 forKey:@"_age"];
    [dog setValue:@20 forKey:@"_weight"];
    [dog run];
    NSLog(@"%@ %@",[dog valueForKey:@"_age"],[dog valueForKey:@"_weight"]);
    //在不需要这个类时释放
//    objc_disposeClassPair(newClass);  48到52行注释，这个才打开
}
void testClass2(){
    //创建类
    Class newClass = objc_allocateClassPair([NSObject class], "Dog2", 0);
    //注册类
    objc_registerClassPair(newClass);
    
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addIvar(newClass, "_weight", 4, 1, @encode(int));
    class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
    
    id dog = [[newClass alloc]init];
    [dog setValue:@10 forKey:@"_age"];
    [dog setValue:@20 forKey:@"_weight"];
    [dog run];
    NSLog(@"%@ %@",[dog valueForKey:@"_age"],[dog valueForKey:@"_weight"]);
    //在不需要这个类时释放
//    objc_disposeClassPair(newClass);
}


void testIvars(){
    //获取成员变量信息
    Ivar ageIvar = class_getInstanceVariable([Person class], "_age");
    NSLog(@"%s %s",ivar_getName(ageIvar),ivar_getTypeEncoding(ageIvar));
    
    //设置和获取成员变量的值
    Ivar nameIvar = class_getInstanceVariable([Person class], "_name");
    Person *person = [[Person alloc]init];
    object_setIvar(person, nameIvar, @"123");
    object_setIvar(person, ageIvar, (__bridge id)(void *)10);
    NSLog(@"%@ %d",person.name,person.age);
    
    //成员变量的数量
    unsigned int count;
    Ivar *ivars = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        //去除i位置的成员变量
        Ivar ivar = ivars[i];
        NSLog(@"%s %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    free(ivars);
}

void testDictToModel(){
    NSDictionary *json = @{
                           @"id" : @20,
                           @"age" : @20,
                           @"weight" : @60,
                           @"name" : @"Jack"
                           //                               @"no" : @30
                           };
    
    Person *person = [Person sl_objectWithJson:json];
    
    
    NSLog(@"%@",person);
}

void testMethodExchange(){
    Person *person = [[Person alloc]init];
    Method runMethod = class_getInstanceMethod([Person class], @selector(run));
    Method testMethod = class_getInstanceMethod([Person class], @selector(test));
    method_exchangeImplementations(runMethod, testMethod);
    [person run];
}

void myrun()
{
    NSLog(@"=======myrun");
}

void testChangeMethod(){
    Person *person = [[Person alloc]init];
//    class_replaceMethod([person class], @selector(run), (IMP)myrun, "v");
    
    class_replaceMethod([person class], @selector(run), imp_implementationWithBlock(^{
        NSLog(@"6666666");
    }), "v");
    [person run];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testSetClass();
//        testGetClass();
//        testClass1();
//        testClass2();
//        testIvars();
//        testDictToModel();
        testMethodExchange();
        testChangeMethod();
        
    }
    return 0;
}

