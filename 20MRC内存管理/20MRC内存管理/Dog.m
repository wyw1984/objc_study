//
//  Dog.m
//  20MRC内存管理
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Dog.h"

@implementation Dog


- (void)run{
    NSLog(@"%s",__func__);
}

- (void)dealloc
{
    [super dealloc];
    NSLog(@"%s",__func__);
}

@end
