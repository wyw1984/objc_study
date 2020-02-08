//
//  AppView.h
//  22.设计模式MVC-变种
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class App,AppView;

@protocol APPViewDelegate <NSObject>

@optional

- (void)appViewDidClick:(AppView *)appView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AppView : UIView

@property (strong, nonatomic) App *app;
@property (weak, nonatomic) id<APPViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
