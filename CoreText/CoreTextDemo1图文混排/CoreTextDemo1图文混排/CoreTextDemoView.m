//
//  CoreTextDemoView.m
//  CoreTextDemo1图文混排
//
//  Created by fengsl on 2020/8/9.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import "CoreTextDemoView.h"
#import <CoreText/CoreText.h>


@interface CoreTextDemoView()

@end


@implementation CoreTextDemoView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGAffineTransform contextCTM = CGContextGetCTM(context);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"\n这里在测试图文混排里在测试图文混排里在测试图文混排，\n我是一个富文本"];
    CTRunDelegateCallbacks callBacks;
    memset(&callBacks,0,sizeof(CTRunDelegateCallbacks));
    callBacks.version = kCTRunDelegateVersion1;
    callBacks.getAscent = ascentCallBacks;
    callBacks.getDescent = descentCallBacks;
    callBacks.getWidth = widthCallBacks;
    NSDictionary * dicPic = @{@"height":@246,@"width":@276};
    CTRunDelegateRef delegate = CTRunDelegateCreate(& callBacks, (__bridge void *)dicPic);
    unichar placeHolder = 0xFFFC;
    NSString * placeHolderStr = [NSString stringWithCharacters:&placeHolder length:1];
    NSMutableAttributedString * placeHolderAttrStr = [[NSMutableAttributedString alloc] initWithString:placeHolderStr];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)placeHolderAttrStr, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    [attributeStr insertAttributedString:placeHolderAttrStr atIndex:20];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    NSInteger length = attributeStr.length;
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    CTFrameDraw(frame, context);
    
    UIImage * image = [UIImage imageNamed:@"head_sample_bg"];
    CGRect imgFrm = [self calculateImageRectWithFrame:frame];
    CGContextDrawImage(context,imgFrm, image.CGImage);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}
static CGFloat ascentCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"height"] floatValue];
}
static CGFloat descentCallBacks(void * ref)
{
    return 0;
}
static CGFloat widthCallBacks(void * ref)
{
    return [(NSNumber *)[(__bridge NSDictionary *)ref valueForKey:@"width"] floatValue];
}


-(CGRect)calculateImageRectWithFrame:(CTFrameRef)frame
{
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frame);
    NSInteger count = [arrLines count];
    CGPoint points[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    for (int i = 0; i < count; i ++) {
        CTLineRef line = (__bridge CTLineRef)arrLines[i];
        NSArray * arrGlyphRun = (NSArray *)CTLineGetGlyphRuns(line);
        for (int j = 0; j < arrGlyphRun.count; j ++) {
            CTRunRef run = (__bridge CTRunRef)arrGlyphRun[j];
            NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[attributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            NSDictionary * dic = CTRunDelegateGetRefCon(delegate);
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            CGPoint point = points[i];
            CGFloat ascent;
            CGFloat descent;
            CGRect boundsRun;
            boundsRun.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            boundsRun.size.height = ascent + descent;
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            boundsRun.origin.x = point.x + xOffset;
            boundsRun.origin.y = point.y - descent;
            CGPathRef path = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(path);
            CGRect imageBounds = CGRectOffset(boundsRun, colRect.origin.x, colRect.origin.y);
            return imageBounds;
        }
    }
    return CGRectZero;
}



@end
