//
//  ViewController.m
//  19.定时器
//
//  Created by fengsl on 2019/7/19.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "SLProxy.h"
#import "SLProxy1.h"
#import "GCDTimer.h"

@interface ViewController ()
@property (strong, nonatomic) CADisplayLink *link;
@property (strong, nonatomic) NSTimer *timer;


@property (strong, nonatomic) dispatch_source_t timer1;
@property (copy, nonatomic) NSString *task;

@end

@implementation ViewController

- (void)testCircleTimer{
    //保证调用频率和屏幕的刷帧率一致，60FPS
//    self.link = [CADisplayLink displayLinkWithTarget:[SLProxy proxyWithTarget:self] selector:@selector(linkTest)];
//    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:[SLProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    //    __weak typeof(self) weakSelf = self;
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        [weakSelf timerTest];
    //    }];
    
    
    //下面这种是没有办法解决循环引用的，因为传递进去的参数无论你是弱指针还是强指针，NSTimer都会强引用引进去的对象的，还是会导致循环
    //    __weak typeof(self) weakSelf = self;
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(timerTest) userInfo:nil repeats:YES];
}

- (void)testGCDTimer{
    NSLog(@"begin");
    
    // 接口设计
    self.task = [GCDTimer execTask:self
                         selector:@selector(doTask)
                            start:2.0
                         interval:1.0
                          repeats:YES
                            async:NO];
    
    //    self.task = [MJTimer execTask:^{
    //        NSLog(@"111111 - %@", [NSThread currentThread]);
    //    } start:2.0 interval:-10 repeats:NO async:NO];
}

- (void)doTask
{
    NSLog(@"doTask - %@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"停止定时器");
    [GCDTimer cancelTask:self.task];
}

- (void)test
{
    
    // 队列
    //    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    uint64_t start = 2.0; // 2秒后开始执行
    uint64_t interval = 1.0; // 每隔1秒执行
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    // 设置回调
    //    dispatch_source_set_event_handler(timer, ^{
    //        NSLog(@"1111");
    //    });
    dispatch_source_set_event_handler_f(timer, timerFire);
    
    // 启动定时器
    dispatch_resume(timer);
    
    self.timer1 = timer;
}

void timerFire(void *param)
{
    NSLog(@"2222 - %@", [NSThread currentThread]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testGCDTimer];
    [self testCircleTimer];
    
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)linkTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.link invalidate];
    //    [self.timer invalidate];
}

@end
