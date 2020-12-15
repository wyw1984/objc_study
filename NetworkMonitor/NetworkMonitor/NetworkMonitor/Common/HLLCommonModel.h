//
//  HLLCommonModel.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLLCommonModel : NSObject


/**
 把模型转为字典方法

 @return 返回模型转字典结果
 */
- (NSDictionary *)toDictionary;

/**
 获取所有的属性key

 @return 返回所有的属性key数组
 */
//- (NSArray *)getAllKeys;

/**
 字典转化为模型

 @param dic 字典
 @return 返回模型
 */
+ (HLLCommonModel *)toModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
