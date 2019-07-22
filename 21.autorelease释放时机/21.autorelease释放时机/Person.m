//
//  Person.m
//  21.autorelease释放时机
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
