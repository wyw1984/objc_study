//
//  SLPerson+Test.h
//  09.Category成员变量
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPerson (Test)

@property (assign, nonatomic) int weight;
@property (copy, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
