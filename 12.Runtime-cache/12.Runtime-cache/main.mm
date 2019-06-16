//
//  main.m
//  12.Runtime-cache
//
//  Created by fengsl on 2019/6/7.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPerson.h"
#import "SLGoodsStudent.h"
#import "SLStudent.h"
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
        
        
        
        //缓存数据测试
        SLGoodsStudent *goodStudent = [[SLGoodsStudent alloc]init];
        sl_objc_class *goodStudentClass = (__bridge sl_objc_class *)[SLGoodsStudent class];
        //可以通过断点调试，查看occupied的值
        [goodStudent goodStudentTest];
        [goodStudent studentTest];
        [goodStudent personTest];
        [goodStudent goodStudentTest];
        [goodStudent studentTest];
        
        NSLog(@"------------------------");
        
        //打印key 和 imp
        cache_t cache = goodStudentClass->cache;
        NSLog(@"%s %p",@selector(personTest),cache.imp(@selector(personTest)));
        NSLog(@"%s %p",@selector(studentTest),cache.imp(@selector(studentTest)));
        NSLog(@"%s %p",@selector(goodStudentTest),cache.imp(@selector(goodStudentTest)));
        
        NSLog(@"################################");
        bucket_t *buckets = cache._buckets;
        bucket_t bucket = buckets[(long long)@selector(studentTest)&cache._mask];
        NSLog(@"%s %p",bucket._key,bucket._imp);
        
        for (int i = 0; i <= cache._mask; i++) {
            bucket_t bucket = buckets[i];
            NSLog(@"%s %p",bucket._key,bucket._imp);
        }
        
    }
    return 0;
}
