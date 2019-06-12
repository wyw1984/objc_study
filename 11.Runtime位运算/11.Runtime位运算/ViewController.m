//
//  ViewController.m
//  11.Runtime位运算
//
//  Created by fengsl on 2019/6/7.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    //    SLOptionsNone = 0,    // 0b0000
    SLOptionsOne = 1<<0,   // 0b0001
    SLOptionsTwo = 1<<1,   // 0b0010
    SLOptionsThree = 1<<2, // 0b0100
    SLOptionsFour = 1<<3   // 0b1000
} SLOptions;



@interface ViewController ()

@end

@implementation ViewController


/*
 0b0001
 0b0010
 0b1000
 ------
 0b1011
 &0b0100
 -------
 0b0000
 */
- (void)setOptions:(SLOptions)options
{
    if (options & SLOptionsOne) {
        NSLog(@"包含了SLOptionsOne");
    }
    
    if (options & SLOptionsTwo) {
        NSLog(@"包含了SLOptionsTwo");
    }
    
    if (options & SLOptionsThree) {
        NSLog(@"包含了SLOptionsThree");
    }
    
    if (options & SLOptionsFour) {
        NSLog(@"包含了SLOptionsFour");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setOptions: SLOptionsOne | SLOptionsFour];
    //[self setOptions: SLOptionsOne + SLOptionsTwo + SLOptionsFour];
}


@end
