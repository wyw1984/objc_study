//
//  ViewController.m
//  22.设计模式MVC-变种
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "AppView.h"
#import "App.h"

@interface ViewController ()<APPViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建view
    AppView *appView = [[AppView alloc]init];
    appView.frame = CGRectMake(100, 100, 100, 150);
    appView.delegate = self;
    [self.view addSubview:appView];
    
    //加载模型数据
    App *app = [[App alloc]init];
    app.name = @"QQ";
    app.image = @"QQ";
    
    //设置数据到view上
    appView.app = app;
}


#pragma mark - AppViewDelegate
- (void)appViewDidClick:(AppView *)appView{
    NSLog(@"控制器监听到了appView的点击");
}


@end
