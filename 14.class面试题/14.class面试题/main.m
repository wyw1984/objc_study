//
//  main.m
//  14.class面试题
//
//  Created by fengsl on 2019/7/10.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>


//@implementation NSObject
//
//- (BOOL)isMemberOfClass:(Class)cls {
//    return [self class] == cls;
//}
//
//- (BOOL)isKindOfClass:(Class)cls {
//    for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
//        if (tcls == cls) return YES;
//    }
//    return NO;
//}
//
//
//+ (BOOL)isMemberOfClass:(Class)cls {
//    return object_getClass((id)self) == cls;
//}
//
//
//+ (BOOL)isKindOfClass:(Class)cls {
//    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
//        if (tcls == cls) return YES;
//    }
//    return NO;
//}
//@end

//void test(id obj)
//{
//    if ([obj isMemberOfClass:[Person class]]) {
//
//    }
//}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"%d", [[NSObject class] isKindOfClass:[NSObject class]]);//1
        NSLog(@"%d", [[NSObject class] isMemberOfClass:[NSObject class]]);//0
        NSLog(@"%d", [[Person class] isKindOfClass:[Person class]]);//0
        NSLog(@"%d", [[Person class] isMemberOfClass:[Person class]]);//0
        
        
        // 这句代码的方法调用者不管是哪个类（只要是NSObject体系下的），都返回YES
        NSLog(@"%d", [NSObject isKindOfClass:[NSObject class]]); // 1
        NSLog(@"%d", [NSObject isMemberOfClass:[NSObject class]]); // 0
        NSLog(@"%d", [Person isKindOfClass:[Person class]]); // 0
        NSLog(@"%d", [Person isMemberOfClass:[Person class]]); // 0
        
        
        id person = [[Person alloc] init];

        NSLog(@"%d", [person isMemberOfClass:[Person class]]);//1
        NSLog(@"%d", [person isMemberOfClass:[NSObject class]]);//0

        NSLog(@"%d", [person isKindOfClass:[Person class]]);//1
        NSLog(@"%d", [person isKindOfClass:[NSObject class]]);//1

        NSLog(@"%d",[Person isMemberOfClass:[Person class]]);//0
        NSLog(@"%d",[Person isKindOfClass:[NSObject class]]);//1
        NSLog(@"%d", [Person isMemberOfClass:object_getClass([Person class])]);//1
        NSLog(@"%d", [Person isKindOfClass:object_getClass([NSObject class])]);//1

        NSLog(@"%d", [Person isKindOfClass:[NSObject class]]);//1
    }
    return 0;
}
