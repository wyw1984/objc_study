//
//  SLPerson.m
//  10.Block初步认识
//
//  Created by fengsl on 2019/6/1.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLPerson.h"

@implementation SLPerson

- (void)dealloc
{
//    [super dealloc];
    NSLog(@"%s", __func__);
}


- (void)test
{
    //    __weak typeof(self) weakSelf = self;
    //    self.block = ^{
    //        NSLog(@"age is %d", weakSelf.age);
    //    };
    
    
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(weakSelf) myself = weakSelf;
        
        NSLog(@"age is %d", myself->_age);
    };
    
    //    __unsafe_unretained typeof(self) weakSelf = self;
    //    self.block = ^{
    //        NSLog(@"age is %d", weakSelf.age);
    //    };
}


@end
