//
//  AppDelegate.m
//  Demo二进制重排
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "SMCallTrace.h"
#import "ViewController.h"
#import "TimeProfiler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)load{
    NSLog(@"AppDelegate");
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//       [SMCallTrace startWithMaxDepth:10];
    [[TimeProfiler shareInstance] TPStartTrace:"AppDelegate"];
    //      [[TimeProfiler shareInstance] TPStartTrace:"大卡页的viewDidLoad函数"];
        // Do any additional setup after loading the view.
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
//
//        [SMCallTrace stop];
//         [SMCallTrace save];
    
    [[TimeProfiler shareInstance] TPStopTrace];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
