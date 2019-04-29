//
//  main.m
//  03.metaclass和superclass神奇功效
//
//  Created by fengsl on 2019/4/29.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Test.h"


@interface SLPerson : NSObject

+ (void)test;

@end

@implementation SLPerson

//+ (void)test{
//    NSLog(@"+[SLPerson test] - %p", self);
//}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"[SLPerson class] - %p", [SLPerson class]);
        NSLog(@"[NSObject class] - %p", [NSObject class]);
        
        [SLPerson test];
        //        objc_msgSend([SLPerson class], @selector(test))
        
         [NSObject test];
        //        objc_msgSend([NSObject class], @selector(test))
    }
    return 0;
}
