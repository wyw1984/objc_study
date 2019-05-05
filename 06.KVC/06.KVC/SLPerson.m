//
//  SLPerson.m
//  06.KVC
//
//  Created by fengsl on 2019/5/4.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLPerson.h"

@implementation SLPerson

//- (int)getAge{
//    return 11;
//}

//- (int)age{
//    return 12;
//}

//- (int)isAge{
//    return 13;
//}
- (int)_age{
    return 14;
}

//- (void)setAge:(int)age{
//    NSLog(@"setAge:%d",age);
//}
//-(void)_setAge:(int)age{
//    NSLog(@"_setAge:%d",age);
//}

- (void)willChangeValueForKey:(NSString *)key{
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey-%@",key);
}

- (void)didChangeValueForKey:(NSString *)key{
    NSLog(@"didChangeValueForKey-begin-%@",key);
}

//默认的返回值就是YES
+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}

@end
