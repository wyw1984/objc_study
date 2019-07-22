//
//  ViewController.m
//  18.线程同步
//
//  Created by fengsl on 2019/7/18.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import "BaseDemo.h"
#import "OSSpinLockDemo.h"
#import "OSUnfairLockDemo.h"
#import "MutexDemo.h"

@interface ViewController ()
@property (nonatomic, strong) BaseDemo *demo;
@end


#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
semaphore = dispatch_semaphore_create(1); \
}); \
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);

//dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

@implementation ViewController

- (void)testSpinlockDemo{
    BaseDemo *demo = [[OSSpinLockDemo alloc]init];
    [demo ticketTest];
}

- (void)testUnfairLockDemo{
    BaseDemo *demo = [[OSUnfairLockDemo alloc]init];
    [demo ticketTest];
}

- (void)testMutexDemo{
    BaseDemo *demo = [[MutexDemo alloc]init];
    [demo ticketTest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testSpinlockDemo];
//    [self testUnfairLockDemo];
    [self testMutexDemo];
}


- (void)test1
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}

- (void)test2
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}

- (void)test3
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}




@end
