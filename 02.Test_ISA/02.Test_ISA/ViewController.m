//
//  ViewController.m
//  02.Test_ISA
//
//  Created by fengsl on 2020/2/15.
//  Copyright © 2020 NeonChange. All rights reserved.
//

#import "ViewController.h"

#import "SLPerson.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SLPerson *person = [[SLPerson alloc]init];
//    __weak SLPerson *weakPerson = person;
//    objc_setAssociatedObject(person, @"name", @"Jack", OBJC_ASSOCIATION_COPY);
    NSLog(@"person:%p",[person class]);

}


@end
