//
//  Person.h
//  15.Runtime应用
//
//  Created by fengsl on 2019/7/11.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (assign, nonatomic) int ID;
@property (assign, nonatomic) int weight;
@property (assign, nonatomic) int age;
@property (copy, nonatomic) NSString *name;
- (void)run;

- (void)test;

@end

NS_ASSUME_NONNULL_END
