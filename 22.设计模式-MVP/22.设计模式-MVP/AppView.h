//
//  AppView.h
//  22.设计模式-MVP
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class AppView;

@protocol AppViewDelegate <NSObject>
@optional
- (void)appViewDidClick:(AppView *)appView;
@end

@interface AppView : UIView
- (void)setName:(NSString *)name andImage:(NSString *)image;
@property (weak, nonatomic) id<AppViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
