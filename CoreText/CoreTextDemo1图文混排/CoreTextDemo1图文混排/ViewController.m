//
//  ViewController.m
//  CoreTextDemo1图文混排
//
//  Created by fengsl on 2020/8/7.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import "ViewController.h"

#import "CoreTextDemoView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CoreTextDemoView *demoView = [[CoreTextDemoView alloc]initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height)];
    demoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:demoView];
  
}


@end
