//
//  Person.m
//  20.copy
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Person.h"

@implementation Person



//- (void)setData:(NSArray *)data
//{
//    if (_data != data) {
//        [_data release];
//        _data = [data copy];
//    }
//}

- (void)dealloc
{
    self.data = nil;
    
    [super dealloc];
}

@end
