//
//  Student.m
//  15.Super
//
//  Created by fengsl on 2019/7/10.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "Student.h"

@implementation Student

- (void)print
{
    [super print];
    
    //    objc_msgSendSuper(
    //    {
    //        self,
    //        [Person class]
    //    }, sel_registerName("print"));
    //
    //    int a = 10;
}

@end
