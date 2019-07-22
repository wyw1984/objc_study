//
//  Person.m
//  20MRC内存管理
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Person.h"


@implementation Person

//自动生成成员变量和属性的setter，getter实现
//@synthesize age = _age;
//
//- (void)setAge:(int)age{
//    _age = age;
//}
//
//- (int)age{
//    return _age;
//}

- (void)setDog:(Dog *)dog
{
    if (_dog != dog) {
        [_dog release];
        _dog = [dog retain];
    }
}

- (Dog *)dog{
    return _dog;
}


- (void)setCar:(Car *)car{
    if (_car != car) {
        [_car release];
        _car = [car retain];
    }
}
- (Car *)car{
    return _car;
}



+ (instancetype)person
{
    return [[[self alloc]init]autorelease];
}


- (void)dealloc{
    self.dog = nil;
    self.car = nil;
    NSLog(@"%s",__func__);
    [super dealloc];
}

@end
