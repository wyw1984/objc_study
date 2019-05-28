//
//  SLPerson+Test.m
//  09.Category成员变量
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#define SLKey [NSString stringWithFormat:@"%p", self]

#import "SLPerson+Test.h"

@implementation SLPerson (Test)

NSMutableDictionary *names_;
NSMutableDictionary *weights_;
+ (void)load
{
    weights_ = [NSMutableDictionary dictionary];
    names_ = [NSMutableDictionary dictionary];
}

- (void)setName:(NSString *)name
{
  
    names_[SLKey] = name;
}

- (NSString *)name
{

    return names_[SLKey];
}

- (void)setWeight:(int)weight
{

    weights_[SLKey] = @(weight);
    
}

- (int)weight
{

    return [weights_[SLKey] intValue];
}


@end
