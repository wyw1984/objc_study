//
//  ViewController.m
//  16.Runtime线程保活
//
//  Created by fengsl on 2019/7/16.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "SLThread.h"

@interface ViewController ()

@property (strong, nonatomic) SLThread *thread;
@property (assign, nonatomic,getter=isStopped) BOOL stopped;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    self.stopped = NO;
    
//    不用addTarget 是不想产生强引用
    self.thread = [[SLThread alloc]initWithBlock:^{
        NSLog(@"%@===begin ===", [NSThread currentThread]);
        
        //往RunLoop里面添加Source、Timer、Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStopped) {
             [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            // NSRunLoop的run方法是无法停止的，它专门用于开启一个永不销毁的线程（NSRunLoop）
            //        [[NSRunLoop currentRunLoop] run];
            /*
             it runs the receiver in the NSDefaultRunLoopMode by repeatedly invoking runMode:beforeDate:.
             In other words, this method effectively begins an infinite loop that processes data from the run loop’s input sources and timers
             */
        }
           NSLog(@"%@----end----", [NSThread currentThread]);
    }];
     [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (IBAction)stop:(id)sender {
    // 在子线程调用stop（waitUnitlDone设置为YES，代表子线程的代码执行完成后，这个方法才会往下走，如果设置为NO会奔溃，因为控制器销毁之后线程还在调用self）
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

// 用于停止子线程的RunLoop
- (void)stopThread
{
    // 设置标记为NO
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    // 清空线程（防止点击停止之后，再点击返回，应为已经退出了runloop，不能再在runloop里面做事情了，这个时候再点击返回的话，会进入stop方法，从而从新调用stopThread方法进入runloop做事，但是runloop已经不存在了）
    self.thread = nil;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
        [self stop:nil];
}

@end
