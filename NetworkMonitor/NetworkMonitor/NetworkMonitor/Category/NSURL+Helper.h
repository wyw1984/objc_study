//
//  NSURL+Helper.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 此NSURL分类用于添加业务扩展参数
 有些业务参数不方便在拦截网络请求时获取(例如：接口描述cmd)，需要业务
 手动添加。通过setExtendedParameter:方法添加在NSURL中的扩展参数，
 将被记录在该次请求的监控数据中。
 */
@interface NSURL (Helper)

//在NSURL中添加扩展参数
@property (nonatomic, strong) NSDictionary *extendedParameter;

@end

NS_ASSUME_NONNULL_END
