//
//  main.m
//  20.copy
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Dog.h"

//拷贝的目的：产生一个副本对象，跟源对象互不影响
//修改了源对象，不会影响副本对象
//修改了副本对象，不会影响源对象


/*
 *
 iOS 提供了2个拷贝方法
 1.copy，不可变拷贝，产生不可变副本
 2.mutableCopy，可变拷贝，产生可变副本
 
 深拷贝和前拷贝
 1.深拷贝：内容拷贝，产生新的对象
 2.浅拷贝：指针拷贝，没有产生新的对象
 */


void test(){
    //        NSString *str1 = [NSString stringWithFormat:@"test"];
    //        NSString *str2 = [str1 copy]; // 返回的是NSString
    //        NSMutableString *str3 = [str1 mutableCopy]; // 返回的是NSMutableString
    
    NSMutableString *str1 = [NSMutableString stringWithFormat:@"test"];
    NSString *str2 = [str1 copy];
    NSMutableString *str3 = [str1 mutableCopy];
    NSLog(@"%p %p %p", str1, str2, str3);
    NSLog(@"%@ %@ %@", str1, str2, str3);
}

void test2()
{
    //字符串长度不一样，打印的地址长度不一样，tagged pointer
    NSString *str1 = [[NSString alloc] initWithFormat:@"test"];
    NSString *str2 = [str1 copy]; // 浅拷贝，指针拷贝，没有产生新对象
//    str1 = @"1111";
    NSMutableString *str3 = [str1 mutableCopy]; // 深拷贝，内容拷贝，有产生新对象
    
    NSLog(@"%@ %@ %@", str1, str2, str3);
    NSLog(@"%p %p %p", str1, str2, str3);
    
    [str3 release];
    [str2 release];
    [str1 release];
}

void test3()
{
    NSMutableString *str1 = [[NSMutableString alloc] initWithFormat:@"test"]; // 1
    NSString *str2 = [str1 copy]; // 深拷贝
    NSMutableString *str3 = [str1 mutableCopy]; // 深拷贝
    
    [str1 release];
    [str2 release];
    [str3 release];
}

void test4()
{
    NSArray *array1 = [[NSArray alloc] initWithObjects:@"a", @"b", nil];
    NSArray *array2 = [array1 copy]; // 浅拷贝
    NSMutableArray *array3 = [array1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", array1, array2, array3);
    
    [array1 release];
    [array2 release];
    [array3 release];
}

void test5()
{
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithObjects:@"a", @"b", nil];
    NSArray *array2 = [array1 copy]; // 深拷贝
    NSMutableArray *array3 = [array1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", array1, array2, array3);
    
    [array1 release];
    [array2 release];
    [array3 release];
}

void test6()
{
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"jack", @"name", nil];
    NSDictionary *dict2 = [dict1 copy]; // 浅拷贝
    NSMutableDictionary *dict3 = [dict1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", dict1, dict2, dict3);
    
    [dict1 release];
    [dict2 release];
    [dict3 release];
}

void test7()
{
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"jack", @"name", nil];
    NSDictionary *dict2 = [dict1 copy]; // 深拷贝
    NSMutableDictionary *dict3 = [dict1 mutableCopy]; // 深拷贝
    
    NSLog(@"%p %p %p", dict1, dict2, dict3);
    
    [dict1 release];
    [dict2 release];
    [dict3 release];
}

void test9(){
    Person *p = [[Person alloc] init];
    
    //        p.data = [NSMutableArray array];
    //        [p.data addObject:@"jack"];
    //        [p.data addObject:@"rose"];
    
    [p release];

}

//自定义copy
void test10(){
    Dog *p1 = [[Dog alloc] init];
    p1.age = 20;
    p1.weight = 50;
    
    Dog *p2 = [p1 copy];
    //        p2.age = 30;
    
    NSLog(@"%@", p1);
    NSLog(@"%@", p2);
    
    [p2 release];
    [p1 release];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        test();
        NSLog(@"---------");
        test2();
    }
    return 0;
}
