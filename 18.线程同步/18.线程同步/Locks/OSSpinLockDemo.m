//
//  OSSpinLockDemo.m
//  18.线程同步
//
//  Created by fengsl on 2019/7/18.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>


@interface OSSpinLockDemo ()
@property (assign, nonatomic) OSSpinLock moneyLock;
@property (assign, nonatomic) OSSpinLock ticketLock;

@end

@implementation OSSpinLockDemo

- (instancetype)init{
    if (self = [super init]) {
        self.moneyLock = OS_SPINLOCK_INIT;
        self.ticketLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__drawMoney{
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}


- (void)__saveMoney{
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
    
}


//调试汇编的时候第一个线程直接过去，第二次断点调试
- (void)__saleTicket
{
    OSSpinLockLock(&_ticketLock);
    
    [super __saleTicket];
    
    OSSpinLockUnlock(&_ticketLock);
}

@end
