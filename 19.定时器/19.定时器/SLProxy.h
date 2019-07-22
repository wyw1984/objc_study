//
//  SLProxy.h
//  19.定时器
//
//  Created by fengsl on 2019/7/19.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLProxy : NSObject

+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic)id target;

@end

NS_ASSUME_NONNULL_END
