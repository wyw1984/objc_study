//
//  NSKVONotifying_SLPerson.m
//  05.KVC&KVO
//
//  Created by fengsl on 2019/5/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "NSKVONotifying_SLPerson.h"

@implementation NSKVONotifying_SLPerson

- (void)setAge:(int)age{
    _NSSetIntValueAndNotify();
}

// 伪代码
void _NSSetIntValueAndNotify()
{
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key
{
    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}


// 屏幕内部实现，隐藏了NSKVONotifying_SLPerson类的存在
- (Class)class
{
    return [SLPerson class];
}

- (void)dealloc
{
    // 收尾工作
}

- (BOOL)_isKVOA
{
    return YES;
}

@end
