//
//  NSURLRequest+Helper.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NSData+GZIP.h"

@interface NSURLRequest (Helper)

@property (nonatomic, assign, readonly) NSUInteger statusLineSize;

@property (nonatomic, assign, readonly) NSUInteger headerSize;

@property (nonatomic, assign, readonly) NSUInteger bodySize;

@end
