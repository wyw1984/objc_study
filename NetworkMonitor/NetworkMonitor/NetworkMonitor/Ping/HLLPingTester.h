//
//  HLLPingTester.h
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/28.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HLLPingManager.h"


@protocol HLLPingDelegate <NSObject>

@optional
- (void)didPingSucccessWithHostName:(NSString *)hostName time:(float)time error:(NSError *)error;

@end



@interface HLLPingTester : NSObject


@property (nonatomic, weak) id<HLLPingDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHostName:(NSString*)hostName NS_DESIGNATED_INITIALIZER;

- (void)startPing;
- (BOOL)isPinging;
- (void)stopPing;



@end


@interface HLLPingItem : NSObject

@property (nonatomic, assign) uint16_t sequence;

@end
