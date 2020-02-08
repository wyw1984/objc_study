//
//  ViewController.m
//  22.设计模式-MVP
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "AppPresenter.h"

@interface ViewController ()
@property (strong, nonatomic) AppPresenter *presenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.presenter = [[AppPresenter alloc]initWithController:self];
}


@end
