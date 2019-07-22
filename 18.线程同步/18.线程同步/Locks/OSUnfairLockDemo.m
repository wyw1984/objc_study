//
//  OSUnfairLockDemo.m
//  18.线程同步
//
//  Created by fengsl on 2019/7/18.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>


@interface OSUnfairLockDemo ()

@property(assign, nonatomic) os_unfair_lock  moneyLock;
@property(assign, nonatomic) os_unfair_lock  ticketLock;

@end

@implementation OSUnfairLockDemo

- (instancetype)init{
    if (self = [super init]) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

//死锁：永远拿不到锁(如果没有解锁)
- (void)__saleTicket
{
    os_unfair_lock_lock(&_ticketLock);
    
    [super __saleTicket];
    
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __saveMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

@end
