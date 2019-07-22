//
//  BaseDemo.h
//  18.线程同步
//
//  Created by fengsl on 2019/7/18.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDemo : NSObject

- (void)moneyTest;
- (void)ticketTest;
- (void)otherTest;


#pragma mark - 暴露给子类去使用
- (void)__saveMoney;
- (void)__drawMoney;
- (void)__saleTicket;

@end

NS_ASSUME_NONNULL_END
