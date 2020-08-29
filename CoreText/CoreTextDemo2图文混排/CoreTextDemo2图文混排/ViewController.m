//
//  ViewController.m
//  CoreTextDemo2图文混排
//
//  Created by fengsl on 2020/8/11.
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
    CoreTextV *textV = [[CoreTextV alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    textV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textV];
}


@end
