//
//  ViewController.m
//  CoreText使用1
//
//  Created by fengsl on 2020/8/10.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextV.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CoreTextV *textV = [[CoreTextV alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    textV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textV];
}


@end
