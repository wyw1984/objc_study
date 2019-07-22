//
//  Dog.h
//  20.copy
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject<NSCopying>
@property (assign, nonatomic) int age;
@property (assign, nonatomic) double weight;

@end

NS_ASSUME_NONNULL_END
