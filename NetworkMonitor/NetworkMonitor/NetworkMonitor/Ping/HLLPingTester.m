//
//  HLLPingTester.m
//  HLLNetworkMonitor
//
//  Created by fengsl on 2020/8/28.
//  Copyright © 2020 fengsl. All rights reserved.
//

#import "HLLPingTester.h"


@interface HLLPingTester()<HLLPingDelegate>
{
    NSTimer *_timer;
    NSDate *_beginDate;
}


@property (nonatomic, strong) HLLPingManager *HLLPingManager;

@property (nonatomic, strong) NSMutableArray<HLLPingItem *> *pingItems;

@property (nonatomic, copy) NSString *hostName;

@end





@implementation HLLPingTester

- (instancetype)initWithHostName:(NSString*)hostName
{
    if (self = [super init])
    {
        self.hostName = hostName;
        self.HLLPingManager = [[HLLPingManager alloc] initWithHostName:hostName];
        self.HLLPingManager.delegate = self;
        self.HLLPingManager.addressStyle = HLLPingManagerAddressStyleAny;

        self.pingItems = [NSMutableArray new];
    }
    return self;
}

- (void)startPing
{
    [self.HLLPingManager start];
}

- (BOOL)isPinging
{
    return [_timer isValid];
}

- (void)stopPing
{
    [_timer invalidate];
    _timer = nil;
    [self.HLLPingManager stop];
}


- (void)actionTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendPingData) userInfo:nil repeats:YES];
}

- (void)sendPingData
{
    [self.HLLPingManager sendPingWithData:nil];
}


#pragma mark - Ping Delegate
- (void)ping:(HLLPingManager *)pinger didStartWithAddress:(NSData *)address
{
    [self actionTimer];
}

- (void)ping:(HLLPingManager *)pinger didFailWithError:(NSError *)error
{
    NSLog(@"hostname:%@, ping失败--->%@", self.hostName, error);
}

- (void)ping:(HLLPingManager *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    HLLPingItem* item = [HLLPingItem new];
    item.sequence = sequenceNumber;
    [self.pingItems addObject:item];
//    NSLog(@"item:%@",item);
//    NSLog(@"self.pingItems:%@",self.pingItems);
    
    _beginDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.pingItems containsObject:item])
        {
            NSLog(@"hostname:%@, 超时---->", self.hostName);
            [self.pingItems removeObject:item];
            if(self.delegate != nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithHostName:time:error:)])
            {
                [self.delegate didPingSucccessWithHostName:self.hostName time:0 error:[NSError errorWithDomain:NSURLErrorDomain code:111 userInfo:nil]];
            }
        }
    });
}
- (void)ping:(HLLPingManager *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error
{
    NSLog(@"hostname:%@, 发包失败--->%@", self.hostName, error);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithHostName:time:error:)])
    {
        [self.delegate didPingSucccessWithHostName:self.hostName time:0 error:error];
    }
}

- (void)ping:(HLLPingManager *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber
{
    float delayTime = [[NSDate date] timeIntervalSinceDate:_beginDate] * 1000;
    [self.pingItems enumerateObjectsUsingBlock:^(HLLPingItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sequence == sequenceNumber)
        {
            [self.pingItems removeObject:obj];
        }
    }];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didPingSucccessWithHostName:time:error:)])
    {
        [self.delegate didPingSucccessWithHostName:self.hostName time:delayTime error:nil];
    }
}

- (void)ping:(HLLPingManager *)pinger didReceiveUnexpectedPacket:(NSData *)packet
{
}


@end


@implementation HLLPingItem



@end
