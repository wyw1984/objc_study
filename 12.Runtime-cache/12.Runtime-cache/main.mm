//
//  main.m
//  12.Runtime-cache
//
//  Created by fengsl on 2019/6/7.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPerson.h"
#import "SLClassInfo.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        SLPerson *person = [[SLPerson alloc] init];
        
         sl_objc_class *cls = (__bridge sl_objc_class *)[SLPerson class];
         class_rw_t *data = cls->data();
        [person personTest];
//        [person personTest:10 height:20];
        
        
        NSLog(@"%s",@encode(int));
        NSLog(@"%s",@encode(float));
        NSLog(@"%s",@encode(id));
        NSLog(@"%s",@encode(SEL));
        
    }
    return 0;
}
