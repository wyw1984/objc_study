//
//  ViewController.m
//  22.设计模式-MVVM
//
//  Created by fengsl on 2019/7/22.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "AppViewModel.h"

@interface ViewController ()
@property (nonatomic, strong) AppViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [[AppViewModel alloc]initWithController:self];
}


@end
