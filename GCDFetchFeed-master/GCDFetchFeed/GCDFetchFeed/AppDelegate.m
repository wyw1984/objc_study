//
//  AppDelegate.m
//  GCDFetchFeed
//
//  Created by DaiMing on 16/1/19.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "AppDelegate.h"

#import "SMRootViewController.h"
#import "SMFeedListViewController.h"
#import "SMMapViewController.h"
#import "SMStyle.h"
#import "SMFeedModel.h"
#import "SMLagMonitor.h"
#import "SMCallTrace.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)test1{
    for (int i = 0; i < 10000; i++) {
//        [self test2];
    }
}


- (void)test2{
    for (int i = 0; i < 10000; i++) {
          [self test3];
      }
}

- (void)test3{
    for (int i = 0; i < 10000; i++) {
          [self test3];
      }
}
- (void)test4{
    for (int i = 0; i < 10000; i++) {
          [self test5];
      }
}
- (void)test5{
    for (int i = 0; i < 10000; i++) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"test" forState:UIControlStateNormal];
      }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //这里是做卡顿监测
//    [[SMLagMonitor shareInstance] beginMonitor];
    [SMCallTrace startWithMaxDepth:10];
//    [self test1];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //首页
    SMRootViewController *rootVC = [[SMRootViewController alloc] init];
//    UINavigationController *homeNav = [self styleNavigationControllerWithRootController:rootVC];
    UINavigationController *homeNav = [self styleNavigationControllerWithRootController:rootVC];
    UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"频道" image:nil tag:1];
    homeTab.titlePositionAdjustment = UIOffsetMake(0, -20);
    homeNav.tabBarItem = homeTab;
    
    //列表
    SMFeedModel *feedModel = [SMFeedModel new];
    feedModel.fid = 0;
    SMFeedListViewController *feedListVC = [[SMFeedListViewController alloc] initWithFeedModel:feedModel];
    UINavigationController *listNav = [self styleNavigationControllerWithRootController:feedListVC];
    UITabBarItem *listTab = [[UITabBarItem alloc] initWithTitle:@"列表" image:nil tag:2];
    listTab.titlePositionAdjustment = UIOffsetMake(0, -18);
    listNav.tabBarItem = listTab;
    
    //map
    SMMapViewController *mapVC = [[SMMapViewController alloc] init];
    UINavigationController *mapNav = [self styleNavigationControllerWithRootController:mapVC];
    UITabBarItem *mapTab = [[UITabBarItem alloc] initWithTitle:@"地图" image:nil tag:2];
    mapTab.titlePositionAdjustment = UIOffsetMake(0, -18);
    mapNav.tabBarItem = mapTab;
    
    UITabBarController *tabBarC = [[UITabBarController alloc]initWithNibName:nil bundle:nil];
    tabBarC.tabBar.tintColor = [SMStyle colorPaperBlack];
    tabBarC.tabBar.barTintColor = [SMStyle colorPaperDark];
    UIView *shaowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tabBarC.tabBar.frame), 0.5)];
    shaowLine.backgroundColor = [UIColor colorWithHexString:@"D8D7D3"];
    [tabBarC.tabBar addSubview:shaowLine];
    tabBarC.tabBar.shadowImage = [UIImage new];
    tabBarC.tabBar.clipsToBounds = YES;
    tabBarC.viewControllers = @[homeNav,listNav,mapNav];
    
    self.window.rootViewController = tabBarC;
    self.window.rootViewController = homeNav;
    [self.window makeKeyAndVisible];
    [SMCallTrace stop];
    [SMCallTrace save];
    return YES;
}

- (UINavigationController *)styleNavigationControllerWithRootController:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = [SMStyle colorPaperBlack];
    nav.navigationBar.barTintColor = [SMStyle colorPaperDark];
    UIView *shaowLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(nav.navigationBar.frame), CGRectGetWidth(nav.navigationBar.frame), 0.5)];
    shaowLine.backgroundColor = [UIColor colorWithHexString:@"D8D7D3"];
    [nav.navigationBar addSubview:shaowLine];
    nav.navigationBar.translucent = NO;
    return nav;
}



@end
