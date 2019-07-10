//
//  ViewController.m
//  15.Super
//
//  Created by fengsl on 2019/7/10.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

/*
 1.print为什么能够调用成功？
 
 2.为什么self.name变成了ViewController等其他内容
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    struct abc = {
    //        self,
    //        [ViewController class]
    //    };
    //    objc_msgSendSuper2(abc, sel_registerName("viewDidLoad"));
    
    //    NSObject *obj2 = [[NSObject alloc] init];
    //
//        NSString *test = @"123";
//
//    id cls = [Person class];
//
//    void *obj = &cls;
//
//    [(__bridge id)obj print];
    
    //    long long *p = (long long *)obj;
    //    NSLog(@"%p %p", *(p+2), [ViewController class]);
    
    //    struct Person_IMPL
    //    {
    //        Class isa;
    //        NSString *_name;
    //    };
    
    NSLog(@"ViewController = %@ , 地址 = %p", self, &self);
    
    id cls = [Person class];
    NSLog(@"Person class = %@ 地址 = %p", cls, &cls);
    
    void *obj = &cls;
    NSLog(@"Void *obj = %@ 地址 = %p", obj,&obj);
    
    [(__bridge id)obj print];
    
    Person *person = [[Person alloc]init];
    NSLog(@"Sark instance = %@ 地址 = %p",person,&person);
    
    [person print];
}
//self 0x7FFEEEE1F8F8
//_cmd 0x7FFEEEE1F8F0
//current_class 0x7FFEEEE1F8E8
//self 0x7FFEEEE1F8E0
//cls 0x7ffeeee1f8d8
//obj 0x7ffeeee1f8d0

//证明两个self存放的内容是一样的
//(lldb) x/g 0x7ffee63088f8
//0x7ffee63088f8: 0x00007fe0cd700750
//(lldb) x/g 0x7ffee63088e0
//0x7ffee63088e0: 0x00007fe0cd700750


@end
