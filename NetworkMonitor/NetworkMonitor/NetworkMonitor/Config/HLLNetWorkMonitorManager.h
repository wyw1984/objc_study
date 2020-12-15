//
//  HLLNetworkMonitorManager.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLNetworkMonitorDef.h"
#import "HLLConfig.h"
#import "HLLPingTester.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLLNetworkMonitorManager : NSObject<HLLNetworkMonitorProtocol>
@property (nonatomic, strong) HLLPingTester *pingTester;

/**
 监控数据输出block
 设置了该block，SDK每收集一条完整数据，就会通过该block回调出去
 如果不设置该block，SDK收集的数据将缓存在数据库中
 */
@property (nonatomic, copy) DataOutputBlock outputBlock;

/**
 获取单例
 
 @return 返回实例
 */
+ (instancetype)sharedNetworkMonitorManager;

/**
 初始化配置
 
 @param config HLLNetworkMonitor相关参数配置
 */
- (void)initConfig:(HLLConfig *)config;




@end

NS_ASSUME_NONNULL_END
