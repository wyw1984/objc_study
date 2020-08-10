//
//  ViewController.m
//  17.GCD
//
//  Created by fengsl on 2019/7/17.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface ViewController ()
@property (assign, nonatomic) int ticketsCount;
@property (assign, nonatomic) int money;

@end

@implementation ViewController

- (void)test0{
    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行任务2");
        NSLog(@"xxxx:%@",[NSThread currentThread]);
        dispatch_sync(queue2, ^{
            NSLog(@"xx:%@",[NSThread currentThread]);
            NSLog(@"执行任务3");
        });
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
}



- (void)test1{
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
              NSLog(@"执行任务1");
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务2");
        }
    });
}
- (void)test2{
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务1");
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务2");
        }
    });
}

- (void)test3{
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务1");
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务2");
        }
    });
}
- (void)test4{
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务1");
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"执行任务2");
        }
    });
}


- (void)testGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2");
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"任务3");
        });
    });
}

//- (void)osspinlock{
//    //初始化
//    OSSpinLock lock = OS_SPINLOCK_INIT;
//    //尝试加锁(如果需要等待就不加锁，直接返回false；如果不需要等待就加锁，返回true)
//    bool result = OSSpinLockTry(&lock);
//    //.....
//    //加锁
//    OSSpinLockLock(&lock);
//    //解锁
//    OSSpinLockUnlock(&lock);
//}
//- (void)osunfairlock{
//    //初始化
//    os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
//    //尝试加锁
//    os_unfair_lock_trylock(&lock);
//    //加锁
//    os_unfair_lock_lock(&lock);
//    //解锁
//    os_unfair_lock_unlock(&lock);
//}


- (void)pthreadmutex1{
    //初始化锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    //初始化锁
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, &attr);
    //尝试加锁
    pthread_mutex_trylock(&mutex);
    //加锁
    pthread_mutex_lock(&mutex);
    //解锁
    pthread_mutex_unlock(&mutex);
    //销毁相关资源
    pthread_mutexattr_destroy(&attr);
    pthread_mutex_destroy(&mutex);
}

- (void)pthreadmutex2{
    //初始化锁的属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    //初始化锁
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, &attr);
    //尝试加锁
    pthread_mutex_trylock(&mutex);
    //加锁
    pthread_mutex_lock(&mutex);
    //解锁
    pthread_mutex_unlock(&mutex);
    //销毁相关资源
    pthread_mutexattr_destroy(&attr);
    pthread_mutex_destroy(&mutex);
}

- (void)pthreadmutex3{
   
    //初始化锁
    pthread_mutex_t mutex;
    //NULL代表使用默认属性
    pthread_mutex_init(&mutex, NULL);
    //初始化条件
    pthread_cond_t condition;
    pthread_cond_init(&condition, NULL);
    //等待条件(进入休眠，放开mutex锁，被唤醒后，会再次对mutex加锁)
    pthread_cond_wait(&condition, &mutex);
    //激活一个等待该条件的线程
    pthread_cond_signal(&condition);
    //激活所有等待该条件的线程
    pthread_cond_broadcast(&condition);
    //销毁资源
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&condition);
}


- (void)test5{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    // dispatch_sync立马在当前线程同步执行任务
}


- (void)test6{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    
    // dispatch_async不要求立马在当前线程同步执行任务
}

- (void)test7{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}


- (void)test8{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue2, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

- (void)test9{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

- (void)test10{
     dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1,NSThread:%@",[NSThread currentThread]); // 任务1
    dispatch_async(queue, ^{
        NSLog(@"2,NSThread:%@",[NSThread currentThread]); // 任务2
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"3,NSThread:%@",[NSThread currentThread]); // 任务3
        });
        NSLog(@"4,NSThread:%@",[NSThread currentThread]); // 任务4
    });
    NSLog(@"5,NSThread:%@",[NSThread currentThread]); // 任务5
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test0];
//    [self test1];
//    [self test2];
    //    [self testGroup];
    //    [self test9];
    //      [self ticketTest];
//    [self test3];
//    [self test4];
//    [self test10];
}


/**
 存钱、取钱演示
 */
- (void)moneyTest
{
    self.money = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saveMoney];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self drawMoney];
        }
    });
}

/**
 存钱
 */
- (void)saveMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

/**
 取钱
 */
- (void)drawMoney
{
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

/**
 卖1张票
 */
- (void)saleTicket
{
    int oldTicketsCount = self.ticketsCount;
    sleep(.2);
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    
    NSLog(@"还剩%d张票 - %@", oldTicketsCount, [NSThread currentThread]);
}

/**
 卖票演示
 */
- (void)ticketTest
{
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
}



- (void)test
{
    NSLog(@"2");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        NSLog(@"1");
//        [self performSelectorOnMainThread:@selector(test) withObject:nil waitUntilDone:0];
//        NSLog(@"3");
//    });
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
      NSLog(@"3");
}
@end
