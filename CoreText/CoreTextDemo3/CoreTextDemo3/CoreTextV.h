//
//  CoreTextV.h
//  CoreTextDemo3
//
//  Created by fengsl on 2020/8/11.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import <UIKit/UIKit.h>

//全局行距
extern const CGFloat kGlobalLineLeading;

extern const CGFloat kPerLineRatio;

//coretext 枚举属性
typedef NS_ENUM(NSInteger, CoreTextDrawType){
    CoreTextDrawPureText,       //绘制纯文本
    CoreTextDrawTextAndPic,     //图文混排
    CoreTextDrawLineByLine,     //以不对齐一行行绘制
    CoreTextDrawLineAlignment,  //以对齐方式一行一行的绘制文本
    CoreTextDrawWithEllipses,   //一行一行的绘制，高度不够加省略号
    CoreTextDrawWithClick       //识别点击特定字符串
};

NS_ASSUME_NONNULL_BEGIN

@interface CoreTextV : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) CoreTextDrawType drawType;


//计算高度的代码
+ (CGFloat)calculateHeightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font type:(CoreTextDrawType)drawtype;

@end

NS_ASSUME_NONNULL_END
