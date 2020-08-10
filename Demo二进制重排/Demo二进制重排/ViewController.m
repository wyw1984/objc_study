//
//  ViewController.m
//  Demo二进制重排
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ViewController.h"
// trace-pc-guard-cb.cc
#include <stdint.h>
#include <stdio.h>
#include <sanitizer/coverage_interface.h>
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

#import "SMCallTrace.h"

@interface ViewController ()

@end

@implementation ViewController

//原子队列
static  OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;
//定义符号结构体
typedef struct {
    void *pc;
    void *next;
}SYNode;


void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//    if (!*guard) return;  // Duplicate the guard check.
    /*  精确定位 哪里开始 到哪里结束!  在这里面做判断写条件!*/
    void *PC = __builtin_return_address(0);
    SYNode *node = malloc(sizeof(SYNode));
    *node = (SYNode){PC,NULL};
    //进入,因为该函数可能在子线程中操作，所以用原子性操作，保证线程安全
    OSAtomicEnqueue(&symbolList, node, offsetof(SYNode, next));
//
}

//https://blog.csdn.net/pjk1129/article/details/44779831  OSAtomicDequeue 是不加锁的filo(first in last out)的队列

void createOrderFile(){
 
    NSMutableArray <NSString *> * symbolNames = [NSMutableArray array];
 
    while (YES) {
        SYNode * node = OSAtomicDequeue(&symbolList, offsetof(SYNode, next));
        if (node == NULL) {
            break;
        }
        Dl_info info;
        dladdr(node->pc, &info);
        NSString * name = @(info.dli_sname);
        BOOL  isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
        NSString * symbolName = isObjc ? name: [@"_" stringByAppendingString:name];
        [symbolNames addObject:symbolName];
    }
    //取反
    NSEnumerator * emt = [symbolNames reverseObjectEnumerator];
    //去重
    NSMutableArray<NSString *> *funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    NSString * name;
    while (name = [emt nextObject]) {
        if (![funcs containsObject:name]) {
            [funcs addObject:name];
        }
    }
    //干掉自己!
    [funcs removeObject:[NSString stringWithFormat:@"%s",__FUNCTION__]];
    //将数组变成字符串
    NSString * funcStr = [funcs  componentsJoinedByString:@"\n"];
 
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"forest.order"];
    NSData * fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
    NSLog(@"%@",funcStr);
}

// This callback is inserted by the compiler as a module constructor
// into every DSO. 'start' and 'stop' correspond to the
// beginning and end of the section with the guards for the entire
// binary (executable or DSO). The callback will be called at least
// once per DSO and may be called multiple times with the same parameters.
 void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;  // Guards should start from 1.
}
//
//// This callback is inserted by the compiler on every edge in the
//// control flow (some optimizations apply).
//// Typically, the compiler will emit the code like this:
////    if(*guard)
////      __sanitizer_cov_trace_pc_guard(guard);
//// But for large functions it will emit a simple call:
////    __sanitizer_cov_trace_pc_guard(guard);
//extern "C" void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
//  if (!*guard) return;  // Duplicate the guard check.
//  // If you set *guard to 0 this code will not be called again for this edge.
//  // Now you can get the PC and do whatever you want:
//  //   store it somewhere or symbolize it and print right away.
//  // The values of `*guard` are as you set them in
//  // __sanitizer_cov_trace_pc_guard_init and so you can make them consecutive
//  // and use them to dereference an array or a bit vector.
//  void *PC = __builtin_return_address(0);
//
//
//    Dl_info info;
//    dladdr(PC, &info);
//       printf("fname:%s \nfbase:%p \nsname:%s \nsaddr:%p\n",
//              info.dli_fname,
//              info.dli_fbase,
//              info.dli_sname,
//              info.dli_saddr);
//
//
//  char PcDescr[1024];
//  // This function is a part of the sanitizer run-time.
//  // To use it, link with AddressSanitizer or other sanitizer.
////  __sanitizer_symbolize_pc(PC, "%p %F %L", PcDescr, sizeof(PcDescr));
//  printf("guard: %p %x PC %s\n", guard, *guard, PcDescr);
//}


+ (void)load{
    NSLog(@"ViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 1000; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
    }
}

void(^block1)(void) = ^(void) {
 
};
 
void test(){
    block1();
 
}
 


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    createOrderFile();
}

@end
