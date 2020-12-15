//
//  HLLConfig.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLConfig.h"

@implementation HLLConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enableLog = YES;
        self.enableNetworkMonitor = NO;
        self.enableInterferenceMode = NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_HLLNetworkMonitor_ON];
    }
    return self;
}

- (void)setUrlWhiteList:(NSArray *)urlWhiteList {
    if (!urlWhiteList) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *urlStr in urlWhiteList) {
        if ([NSURL URLWithString:urlStr].host) {
            [array addObject:urlStr];
        }
    }
    _urlWhiteList = array;
}


@end
