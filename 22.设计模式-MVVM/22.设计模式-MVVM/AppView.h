//
//  AppView.h
//  22.设计模式-MVVM
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AppView, AppViewModel;

@protocol AppViewDelegate <NSObject>
@optional
- (void)appViewDidClick:(AppView *)appView;
@end

@interface AppView : UIView


@property (weak, nonatomic) AppViewModel *viewModel;
@property (weak, nonatomic) id<AppViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
