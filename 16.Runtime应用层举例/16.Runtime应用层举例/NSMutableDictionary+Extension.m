//
//  NSMutableDictionary+Extension.m
//  16.Runtime应用层举例
//
//  Created by fengsl on 2019/7/15.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Extension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSDictionaryM");
        Method method1 = class_getInstanceMethod(cls, @selector(setObject:forKeyedSubscript:));
        Method method2 = class_getInstanceMethod(cls, @selector(custom_setObject:forKeyedSubscript:));
        method_exchangeImplementations(method1, method2);
        
        Class cls2 = NSClassFromString(@"__NSDictionaryI");
        Method method3 = class_getInstanceMethod(cls2, @selector(objectForKeyedSubscript:));
        Method method4 = class_getInstanceMethod(cls2, @selector(custom_objectForKeyedSubscript:));
        method_exchangeImplementations(method3, method4);
    });
}

- (void)custom_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) {
        return;
    }
    [self custom_setObject:obj forKeyedSubscript:key];
}

- (id)custom_objectForKeyedSubscript:(id)key{
    if (!key) {
        return nil;
    }
    return [self custom_objectForKeyedSubscript:key];
}

@end
