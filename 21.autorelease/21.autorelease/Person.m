//
//  Person.m
//  21.autorelease
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [super dealloc];
}
void person_test()
{
    NSLog(@"person - test");
}
@end
