//
//  NSObject+Test.m
//  03.metaclass和superclass神奇功效
//
//  Created by fengsl on 2019/4/29.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "NSObject+Test.h"

@implementation NSObject (Test)

//+ (void)test{
//     NSLog(@"+[NSObject test] - %p", self);
//}

- (void)test{
    NSLog(@"-[NSObject test 对象方法] - %p", self);
}

@end
