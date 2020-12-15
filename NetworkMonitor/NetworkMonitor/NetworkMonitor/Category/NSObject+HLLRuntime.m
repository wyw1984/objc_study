//
//  NSObject+HLLRuntime.m
//  Network
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "NSObject+HLLRuntime.h"




@implementation NSObject (HLLRuntime)

+ (void)HLL_swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Class cls = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(cls, oriSel);
    Method swizzledAddObserverMethod = class_getClassMethod(cls, swiSel);
    
    [self HLL_swizzleMethod:originAddObserverMethod anotherMethod:swizzledAddObserverMethod];
}

+ (void)HLL_swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self HLL_swizzleMethod:originAddObserverMethod anotherMethod:swizzledAddObserverMethod];
}

+ (void)HLL_swizzleMethod:(Method)method1 anotherMethod:(Method)method2 {
    if (!method1 || !method2) {
        NSLog(@"LLDebugTool: Can't swizzle method, because method is nil");
        return;
    }
    method_exchangeImplementations(method1, method2);
}

+ (NSArray *)HLL_getPropertyNames {
    // Property count
    unsigned int count;
    // Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // Get names
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [array addObject:name];
        }
    }
    free(properties);
    return array;
}

- (NSArray *)HLL_getClassIvars{
    return [[self class] HLL_getClassIvars];
}

+ (NSArray *)HLL_getClassIvars{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList([self class], &numIvars);
    //Ivar *vars = class_copyIvarList([UIView class], &numIvars);
    
    NSString *key=nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < numIvars; i++) {

        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
//        NSLog(@"variable name :%@", key);
        if (key) {
            [array addObject:key];
        }
        key = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
//        NSLog(@"variable type :%@", key);
    }
    free(vars);
    return array;
    
}

- (NSArray *)HLL_getPropertyNames {
    return [[self class] HLL_getPropertyNames];
}

+ (NSArray *)HLL_getInstanceMethodNames {
    unsigned int count;
    // Get methods list.
    Method *methods = class_copyMethodList([self class], &count);
    // Get name
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if (name.length) {
            [array addObject:name];
        }
    }
    free(methods);
    return array;
}

+ (NSArray *)HLL_getClassMethodNames {
    unsigned int count;
    // Get methods list.
    Method *methods = class_copyMethodList(object_getClass([self class]), &count);
    // Get name
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *name = NSStringFromSelector(sel);
        if (name.length) {
            [array addObject:name];
        }
    }
    free(methods);
    return array;
}

- (void)HLL_setStringProperty:(NSString *)string key:(const void *)key {
    objc_setAssociatedObject(self, key, string, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *_Nullable)HLL_getStringProperty:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

- (void)HLL_setCGFloatProperty:(CGFloat)number key:(const void *)key {
    objc_setAssociatedObject(self, key, @(number), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)HLL_getCGFloatProperty:(const void *)key {
    return (CGFloat)[objc_getAssociatedObject(self, key) doubleValue];
}

@end
