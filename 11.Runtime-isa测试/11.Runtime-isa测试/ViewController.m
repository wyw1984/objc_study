//
//  ViewController.m
//  11.Runtime-isa测试
//
//  Created by songlin on 2019/6/4.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Person *person = [[Person alloc]init];
    NSLog(@"person class:%p",[person class]);
    
    
    
    //为person添加弱引用
//    __weak Person *weakPerson = person;
//    // 为person添加关联对象
//    objc_setAssociatedObject(person, @"name", @"forest", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
    
    NSLog(@"person object:%@",person);
    
    
    NSLog(@"证明isa共用体的字段");
}


@end
