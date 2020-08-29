//
//  ViewController.m
//  CoreTextDemo3
//
//  Created by fengsl on 2020/8/11.
//  Copyright © 2020 com.forest. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextV.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CoreTextV *textV = [[CoreTextV alloc]initWithFrame:CGRectZero];
    textV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textV];
    NSString *content = @"床前明月光，疑是地上霜，举头望明月，低头思故乡，大江东去浪淘尽，千古风流人物，还看今朝，天生我才必有用，千金散尽还复来，去年今日此门中，人面桃花相映红，人面不知何处去，桃花依旧笑春风，千呼万唤始出来，犹抱琵琶半遮面，😳😊😳😊😳😊😳，临行密密缝，游子身上衣，意恐迟迟归756613301，@冯宋林123 ，i love you，你会否相信吗，你会否也像我，妙妙等待遥远仲夏";
    textV.font = [UIFont systemFontOfSize:15];
    textV.text = content;
    textV.drawType = CoreTextDrawLineAlignment;
    CGFloat realWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [CoreTextV calculateHeightWithText:content width:realWidth font:textV.font type:textV.drawType];
    //控制行数
    CGFloat maxHeight = (textV.font.pointSize * kPerLineRatio) * 6;
    
    if (height > maxHeight && textV.drawType == CoreTextDrawWithEllipses) {
        height = maxHeight;
    }
    NSLog(@"height = %f", height);
    //计算出高度
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(UIApplication.sharedApplication.statusBarFrame.size.height);
        make.height.mas_equalTo(height);
    }];
}


@end
