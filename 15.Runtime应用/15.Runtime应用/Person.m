//
//  Person.m
//  15.Runtime应用
//
//  Created by fengsl on 2019/7/11.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)run
{
    NSLog(@"%s", __func__);
}

- (void)test
{
    NSLog(@"%s", __func__);
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
    }
    return self;
}
@end
