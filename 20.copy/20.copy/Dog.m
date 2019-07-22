//
//  Dog.m
//  20.copy
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

//自定义copy

#import "Dog.h"

@implementation Dog

- (id)copyWithZone:(NSZone *)zone
{
    Dog *person = [[Dog allocWithZone:zone] init];
    person.age = self.age;
    //    person.weight = self.weight;
    return person;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"age = %d, weight = %f", self.age, self.weight];
}


@end
