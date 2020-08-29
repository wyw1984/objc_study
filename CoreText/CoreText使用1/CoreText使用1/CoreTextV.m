//
//  CoreTextV.m
//  CoreText使用1
//
//  Created by fengsl on 2020/8/10.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import "CoreTextV.h"
#import <CoreText/CoreText.h>

@implementation CoreTextV

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    //1.获取上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //[a,b,c,d,tx,ty]
    NSLog(@"转换前的坐标:%@",NSStringFromCGAffineTransform(CGContextGetCTM(contextRef)));
    //2.转换坐标系，CoreText的原点在左下角，UIKit原点在左上角
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    
    //3.这两种转换坐标的方式一样
//    2.1
    CGContextTranslateCTM(contextRef, 0, self.bounds.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    //2.2
//    CGContextConcatCTM(contextRef, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    NSLog(@"转换后的坐标:%@",NSStringFromCGAffineTransform(CGContextGetCTM(contextRef)));
    
    //3.创建绘制区域，可以对path进行个性化裁剪以改变显示区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
//    CGPathAddEllipseInRect(path, NULL, self.bounds);
    
    //4.创建需要绘制的文字
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:@"学习篮球羽毛球，可以笑的话，不会哭，可知道拿回孤独偏偏我没有遇上，无法港爱这个一种，遇上信服，你说加我邓毅要爆不从，是在无法港爱这一刻，你的刺青，请不要继续，以为山贼工行是"];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
    [attributed addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, attributed.length - 6)];
     [attributed addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 5)];
    
    //设置行距等样式
    CGFloat lineSpace = 10;//行距一般取决于这个值
    CGFloat lineSpaceMax = 20;
    CGFloat lineSpaceMin = 2;
    const CFIndex kNumberOfSettings = 3;
    
    //结构体数组
    CTParagraphStyleSetting settings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpace},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpaceMax},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpaceMin}
    };
    
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, kNumberOfSettings);
    
    // 单个元素的形式
    // CTParagraphStyleSetting theSettings = {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpace};
    // CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(&theSettings, kNumberOfSettings);

    // 两种方式皆可
    // [attributed addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)theParagraphRef range:NSMakeRange(0, attributed.length)];

    // 将设置的行距应用于整段文字
    [attributed addAttribute:NSParagraphStyleAttributeName value:(__bridge id)(paragraphRef) range:NSMakeRange(0, attributed.length)];
    
    CFRelease(paragraphRef);
    
    //5.根据NSArrtibute
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributed);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributed.length), path, NULL);
    
    //6.绘制除图片意外的部分
    CTFrameDraw(ctFrame, contextRef);
    
    //7.内存管理，ARC不能管理CF开头的对象，需要我们自己手动释放内存
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(ctFrame);

}




@end
