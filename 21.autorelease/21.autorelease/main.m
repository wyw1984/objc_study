//
//  main.m
//  21.autorelease
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"


/*
int main(int argc, const char * argv[]) {
    { __AtAutoreleasePool __autoreleasepool;
        
        
        for (int i = 0; i < 1000; i++) {
            Person *person = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init")), sel_registerName("autorelease"));
        }
        
    }
    return 0;
}
*/

//系统方法
extern void _objc_autoreleasePoolPrint(void);

void test(){
    //       这里面转换成C++源码相当于 atautoreleasepoolobj = objc_autoreleasePoolPush();
    for (int i = 0; i < 1000; i++) {
        Person *person = [[[Person alloc] init] autorelease];
    } // 8000个字节
    //objc_autoreleasePoolPop(atautoreleasepoolobj);
}
    

int main(int argc, const char * argv[]) {
    @autoreleasepool {//r1 = push()
//        test();
        
        Person *p1 = [[[Person alloc] init] autorelease];
        Person *p2 = [[[Person alloc] init] autorelease];
        
        @autoreleasepool { // r2 = push()
            for (int i = 0; i < 600; i++) {
                Person *p3 = [[[Person alloc] init] autorelease];
            }
            
            @autoreleasepool { // r3 = push()
                Person *p4 = [[[Person alloc] init] autorelease];
                
                _objc_autoreleasePoolPrint();
                person_test();
            } // pop(r3)
            
        } // pop(r2)
    }//pop(1)
    return 0;
}

/*
struct __AtAutoreleasePool {
 //构造函数，在创建结构体的时候调用
    __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
 //析构函数，在结构体销毁的时候调用
    ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
    void * atautoreleasepoolobj;
};
 
*/
