//
//  AppViewModel.m
//  22.设计模式-MVVM
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "AppViewModel.h"
#import "App.h"
#import "AppView.h"

@interface AppViewModel ()<AppViewDelegate>

@property (weak, nonatomic) UIViewController *controller;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *image;

@end

@implementation AppViewModel

- (instancetype)initWithController:(UIViewController *)controller
{
    if (self = [super init]) {
        self.controller = controller;
        
        // 创建View
        AppView *appView = [[AppView alloc] init];
        appView.frame = CGRectMake(100, 100, 100, 150);
        appView.delegate = self;
        appView.viewModel = self;
        [controller.view addSubview:appView];
        
        // 加载模型数据
        App *app = [[App alloc] init];
        app.name = @"QQ";
        app.image = @"QQ";
        
        // 设置数据
        self.name = app.name;
        self.image = app.image;
    }
    return self;
}

#pragma mark - MJAppViewDelegate
- (void)appViewDidClick:(AppView *)appView
{
    NSLog(@"viewModel 监听了 appView 的点击");
}

@end
