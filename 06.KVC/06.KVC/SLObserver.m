//
//  SLObserver.m
//  06.KVC
//
//  Created by fengsl on 2019/5/4.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLObserver.h"

@implementation SLObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"observeValueForKeyPath - %@",change);
}

@end
