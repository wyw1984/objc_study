//
//  ViewController.m
//  16.Runtime应用层举例
//
//  Created by fengsl on 2019/7/15.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *obj = nil;
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:@"jack"];
//    [array insertObject:obj atIndex:0];
//    NSLog(@"交换数组插入方法");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"name"] = @"jack";
    dict[obj] = @"rose";
    dict[@"age"] = obj;
    NSLog(@"字典的内容是:%@",dict);
}

- (IBAction)click1:(id)sender {
     NSLog(@"%s",__func__);
}


- (IBAction)click2:(id)sender {
    NSLog(@"%s",__func__);
}


- (IBAction)click3:(id)sender {
    NSLog(@"%s",__func__);
}

@end
