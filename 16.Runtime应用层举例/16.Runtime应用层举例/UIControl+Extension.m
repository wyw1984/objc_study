//
//  UIControl+Extension.m
//  16.Runtime应用层举例
//
//  Created by fengsl on 2019/7/15.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "UIControl+Extension.h"
#import <objc/runtime.h>

@implementation UIControl (Extension)

+ (void)load
{
    //hook:钩子函数
    Method method1 = class_getInstanceMethod(self,@selector(sendAction:to:forEvent:));
    Method method2 = class_getInstanceMethod(self,@selector(custom_sendAction:to:forEvent:));
    method_exchangeImplementations(method1,method2);
}

- (void)custom_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    NSLog(@"-%@-%@-%@",self,target,NSStringFromSelector(action));
    //    if ([self isKindOfClass:[UIButton class]]) {
    //        // 拦截了所有按钮的事件
    //
    //    }
}

@end
