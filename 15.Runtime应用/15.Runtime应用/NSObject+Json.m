//
//  NSObject+Json.m
//  15.Runtime应用
//
//  Created by fengsl on 2019/7/11.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "NSObject+Json.h"
#import <objc/runtime.h>

@implementation NSObject (Json)
+ (instancetype)sl_objectWithJson:(NSDictionary *)json{
    id obj = [[self alloc] init];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    for (int i = 0; i < count; i++) {
        // 取出i位置的成员变量
        Ivar ivar = ivars[i];
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        
        // 设值
        id value = json[name];
        if ([name isEqualToString:@"ID"]) {
            value = json[@"id"];
        }
        [obj setValue:value forKey:name];
    }
    free(ivars);
    
    return obj;
}

@end
