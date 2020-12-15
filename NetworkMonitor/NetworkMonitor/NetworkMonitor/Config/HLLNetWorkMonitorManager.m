//
//  HLLNetworkMonitorManager.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLNetworkMonitorManager.h"
#import "NSURLSession+Helper.h"
#import "NSURLConnection+Helper.h"
#import "HLLCache.h"

@interface HLLNetworkMonitorManager()<HLLPingDelegate>


@property (nonatomic, strong) HLLConfig *monitorConfig;
@end


@implementation HLLNetworkMonitorManager


+ (instancetype)sharedNetworkMonitorManager {
    static HLLNetworkMonitorManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HLLNetworkMonitorManager alloc] init];
    });
    return manager;
}


- (void)initConfig:(HLLConfig *)config {
    self.monitorConfig = config;
}

- (void)startPing{
    [HLLNetworkMonitorManager sharedNetworkMonitorManager].pingTester = [[HLLPingTester alloc] initWithHostName:@"app.61draw.com"];
    [HLLNetworkMonitorManager sharedNetworkMonitorManager].pingTester.delegate = self;
    [[HLLNetworkMonitorManager sharedNetworkMonitorManager].pingTester startPing];
}


- (BOOL)isPing{
   return [[HLLNetworkMonitorManager sharedNetworkMonitorManager].pingTester isPinging];
}

- (void)stopPing{
     [[HLLNetworkMonitorManager sharedNetworkMonitorManager].pingTester stopPing];
}

- (void)didPingSucccessWithHostName:(NSString *)hostName time:(float)time error:(NSError *)error;
{
    NSString *string = @"";
       if (error)
       {
           string = error.localizedDescription;
       }
       else
       {
           NSLog(@"hostName：%@, %@", hostName, [[NSString stringWithFormat:@"%d", (int)time] stringByAppendingString:@"ms"]);
           string = [hostName stringByAppendingFormat:@"%@", [[NSString stringWithFormat:@"%d", (int)time] stringByAppendingString:@"ms"]];
       }
    
     [HLLNetworkMonitorManager sharedNetworkMonitorManager].outputBlock = ^(NSString *traceId, NSDictionary *data) {
        
           NSMutableDictionary *monitorDict = [NSMutableDictionary dictionaryWithDictionary:data];
           [monitorDict setValue:string forKey:@"pd"];
           NSLog(@"接口监控%@",monitorDict);
           [self stopPing];
       };
}



- (void)start {
    if (self.monitorConfig.enableNetworkMonitor && ![HLLNetUtils isHLLNetworkMonitorOn]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSURLSession hook];
            [NSURLConnection hook];
        });
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_HLLNetworkMonitor_ON];
    }
}


- (void)stop {
    if (self.monitorConfig.enableNetworkMonitor && [HLLNetUtils isHLLNetworkMonitorOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_HLLNetworkMonitor_ON];
    }
}


- (HLLConfig *)getConfig {
    return _monitorConfig;
}

- (void)setExtendedParameter:(NSDictionary *)params traceId:(NSString *)traceId {
    if (_monitorConfig.enableInterferenceMode) {
        [[HLLCache sharedHLLCache] cacheExtension:params traceId:traceId];
    }
}

- (void)finishColection:(NSString *)traceId {
    if (_monitorConfig.enableInterferenceMode) {
        [[HLLCache sharedHLLCache] persistData:traceId];
    }
    [[HLLCache sharedHLLCache] persistData:traceId];
}

- (NSArray *)getAllData {
    return [[HLLCache sharedHLLCache] getAllData];
}

- (void)removeAllData {
    [[HLLCache sharedHLLCache] removeAllData];
}


@end
