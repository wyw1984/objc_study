//
//  ViewController.m
//  16.RunLoop
//
//  Created by fengsl on 2019/7/16.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "SLThread.h"

@interface ViewController ()

@property (strong, nonatomic) SLThread *thread;

@end

@implementation ViewController

NSMutableDictionary *runloops;

void observeRunLoopActicities(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit");
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    NSLog(@"%p %p", [NSRunLoop currentRunLoop], [NSRunLoop mainRunLoop]);
    //    NSLog(@"%p %p", CFRunLoopGetCurrent(), CFRunLoopGetMain());
    //    NSLog(@"=================");
    //    NSLog(@"%@",[NSRunLoop mainRunLoop]);
    
    // 创建Observer
    //    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observeRunLoopActicities, NULL);
    //    // 添加Observer到RunLoop中
    //    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    //    // 释放
    //    CFRelease(observer);
    
    // 创建Observer
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        switch (activity) {
//            case kCFRunLoopEntry: {
//                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//                NSLog(@"kCFRunLoopEntry - %@", mode);
//                CFRelease(mode);
//                break;
//            }
//                
//            case kCFRunLoopExit: {
//                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
//                NSLog(@"kCFRunLoopExit - %@", mode);
//                CFRelease(mode);
//                break;
//            }
//                
//            default:
//                break;
//        }
//    });
//    // 添加Observer到RunLoop中
//    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
//    // 释放
//    CFRelease(observer);
    
    
//    static int count = 0;
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%d", ++count);
//    }];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
//
//     NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
//     NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
//     timer能在_commonModes数组中存放的模式下工作
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"%d", ++count);
    //    }];
    
    //线程保活
    self.thread = [[SLThread alloc]initWithTarget:self selector:@selector(run) object:nil];
    [self.thread start];
    
}

// 这个方法的目的：线程保活
- (void)run {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    
    // 往RunLoop里面添加Source\Timer\Observer
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"%s ----end----", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //断点调试堆栈信息
//    NSLog(@"%s",__func__);
    
    //测试定时器调用
    //    [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"定时器-----------");
    //    }];
    
    //测试线程保活
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
    
}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}



@end
