//
//  HLLCommonModel.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLCommonModel.h"
#import <objc/runtime.h>

@implementation HLLCommonModel

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:name];
        
        if (value) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                [dic addEntriesFromDictionary:value];
            } else {
                [dic setValue:value forKey:name];
            }
        }
    }
    free(properties);
    return dic;
}

+ (HLLCommonModel *)toModel:(NSDictionary *)dic {
    
    HLLCommonModel *model = [[[self class] alloc] init];
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        id value = dic[name];
        
        if (value) {
            [model setValue:value forKey:name];
        }
    }
    free(properties);
    return model;
}

@end
