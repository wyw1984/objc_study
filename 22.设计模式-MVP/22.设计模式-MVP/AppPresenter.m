//
//  AppPresenter.m
//  22.设计模式-MVP
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "AppPresenter.h"
#import "App.h"
#import "AppView.h"

@interface AppPresenter ()<AppViewDelegate>

@property (weak, nonatomic) UIViewController *controller;

@end

@implementation AppPresenter

- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        self.controller = controller;
        
        //创建view
        AppView *appView = [[AppView alloc]init];
        appView.frame = CGRectMake(100, 100, 100, 150);
        appView.delegate = self;
        [controller.view addSubview:appView];
        
        // 加载模型数据
        App *app = [[App alloc] init];
        app.name = @"QQ";
        app.image = @"QQ";
        
        // 赋值数据
        [appView setName:app.name andImage:app.image];
    }
    return self;
}

#pragma mark - MJAppViewDelegate
- (void)appViewDidClick:(AppView *)appView
{
    NSLog(@"presenter 监听了 appView 的点击");
}

@end
