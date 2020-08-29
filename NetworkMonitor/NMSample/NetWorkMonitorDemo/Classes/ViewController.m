//
//  ViewController.m
//  NetworkMonitorSample
//
//  Created by fengslon 2018/4/23.
//  Copyright © Copyright © 2020 Ssky. All rights reserved.
//

#import "ViewController.h"
#import "NSURLSessionVC.h"
#import "NSURLConnectionVC.h"
#import "AFNetworkingVC.h"
#import "WebViewController.h"
#import <HLLNetworkMonitor/HLLNetworkMonitor.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
}

- (void)initViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"网络监控调试";
    UIButton *afnetworking = [[UIButton alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [afnetworking setBackgroundColor:[UIColor blueColor]];
    [afnetworking setTitle:@"AFNetworking" forState:UIControlStateNormal];
    [afnetworking addTarget:self action:@selector(afnetworking) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:afnetworking];
    
    UIButton *urlconnection = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [urlconnection setBackgroundColor:[UIColor blueColor]];
    [urlconnection setTitle:@"URLConnection" forState:UIControlStateNormal];
    [urlconnection addTarget:self action:@selector(urlconnection) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:urlconnection];
    
    UIButton *urlsession = [[UIButton alloc] initWithFrame:CGRectMake(20, 260, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [urlsession setBackgroundColor:[UIColor blueColor]];
    [urlsession setTitle:@"URLSession" forState:UIControlStateNormal];
    [urlsession addTarget:self action:@selector(urlsession) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:urlsession];
    
    
#pragma mark webview 这一块不能通过拦击NSURLSession相关代理方法拦截，这个迟点再研究一下怎么搞
    UIButton *uiwebview = [[UIButton alloc] initWithFrame:CGRectMake(20, 330, [UIScreen mainScreen].bounds.size.width - 40, 50)];
    [uiwebview setBackgroundColor:[UIColor blueColor]];
    [uiwebview setTitle:@"UIWebView" forState:UIControlStateNormal];
//    uiwebview.hidden = YES;
    [uiwebview addTarget:self action:@selector(uiwebview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uiwebview];
}

#pragma mark button-click
- (void)urlsession {
    
    NSURLSessionVC *sessionVC = [[NSURLSessionVC alloc] init];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

- (void)urlconnection {
    NSURLConnectionVC *connectionVC = [[NSURLConnectionVC alloc] init];
    [self.navigationController pushViewController:connectionVC animated:YES];
}

- (void)afnetworking {
    AFNetworkingVC *afnetworkingVC = [[AFNetworkingVC alloc] init];
    [self.navigationController pushViewController:afnetworkingVC animated:YES];
}

- (void)uiwebview {
    WebViewController *webviewVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webviewVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
