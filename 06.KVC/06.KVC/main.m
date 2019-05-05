//
//  main.m
//  06.KVC
//
//  Created by fengsl on 2019/5/4.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLObserver.h"
#import "SLPerson.h"


void test1(){
    SLObserver *observer = [[SLObserver alloc]init];
    SLPerson *person = [[SLPerson alloc]init];
    
    //添加kvo监听
    [person addObserver:observer forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    //通过更改成员变量age值
     [person willChangeValueForKey:@"age"];
     person->_age = 10;
     [person didChangeValueForKey:@"age"];
    
    // 移除KVO监听
    [person removeObserver:observer forKeyPath:@"age"];
}

//证明kvc是否会触发kvo
void test(){
    SLObserver *observer = [[SLObserver alloc]init];
    SLPerson *person = [[SLPerson alloc]init];
    
    //添加kvo监听
    [person addObserver:observer forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    //通过kvc更改属性age值
    [person setValue:@10 forKey:@"age"];
    
    // 移除KVO监听
    [person removeObserver:observer forKeyPath:@"age"];

}

//寻找赋值原理
void test2(){
    SLPerson *person = [[SLPerson alloc]init];
    
    //通过kvc更改属性age值
    [person setValue:@10 forKey:@"age"];
}


//测试寻找过程
void test4(){
    SLPerson *person = [[SLPerson alloc] init];
            person->_age = 10;
//            person->_isAge = 11;
//            person->age = 12;
//            person->isAge = 13;
    
    
    NSLog(@"%@", [person valueForKey:@"age"]);

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        test4();
        
    }
    return 0;
}


