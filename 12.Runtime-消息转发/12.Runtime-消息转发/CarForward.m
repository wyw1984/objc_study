//
//  CarForward.m
//  12.Runtime-消息转发
//
//  Created by fengsl on 2019/6/16.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "CarForward.h"

@implementation CarForward

- (int)driving:(int)time{
    NSLog(@"car driving %d",time);
    return  time * 2;
}



@end
