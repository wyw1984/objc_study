//
//  AppPresenter.h
//  22.设计模式-MVP
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppPresenter : NSObject

- (instancetype)initWithController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
