//
//  ViewController.m
//  16.Runtime线程保活
//
//  Created by fengsl on 2019/7/16.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "SLPermenantThread.h"


@interface ViewController ()

@property (strong, nonatomic) SLPermenantThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[SLPermenantThread alloc]init];
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务-- %@",[NSThread currentThread]);
    }];
}

- (IBAction)stop:(id)sender {
    [self.thread stop];
}





- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    
}

@end
