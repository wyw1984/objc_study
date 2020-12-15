//
//  NSURL+Helper.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/27.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "NSURL+Helper.h"
#import <objc/runtime.h>


static char *NSURLNMKey = "NSURLNMKey";


@implementation NSURL (Helper)


- (void)setExtendedParameter:(NSDictionary *)extendedParameter {
    objc_setAssociatedObject(self, NSURLNMKey, extendedParameter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)extendedParameter {
    return objc_getAssociatedObject(self, NSURLNMKey);
}


@end
