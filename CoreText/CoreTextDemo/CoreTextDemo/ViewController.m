//
//  ViewController.m
//  CoreTextDemo
//
//  Created by Wicky on 16/4/22.
//  Copyright © 2016年 Wicky. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextV.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoreTextV * coreTextV = [[CoreTextV alloc] initWithFrame:self.view.bounds];
    coreTextV.backgroundColor = [UIColor blackColor];
    [self.view addSubview:coreTextV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
