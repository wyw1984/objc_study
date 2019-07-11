//
//  NSObject+Json.h
//  15.Runtime应用
//
//  Created by fengsl on 2019/7/11.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Json)

+ (instancetype)sl_objectWithJson:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
