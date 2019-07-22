//
//  ViewController.m
//  20MRC内存管理
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Dog.h"

@interface ViewController ()


@property (retain, nonatomic) NSMutableArray *data;

@end

@implementation ViewController


-(void)test{
    Dog *dog = [[Dog alloc]init];//1
    Person *person1 = [[Person alloc]init];
    [person1 setDog:dog];//2
    
    Person *person2 = [[Person alloc] init];
    [person2 setDog:dog];//3
    
    [dog release];//2
    [person1 release];//1
    [[person2 dog] run];
    [person2 release];//0
}


-(void)test1{
    Dog *dog1 = [[Dog alloc]init];//dog1:1
    Dog *dog2 = [[Dog alloc]init];//dog2:1
    
    Person *person = [[Person alloc]init];
    [person setDog:dog1];//dog1:2
    [person setDog:dog2];//dog2:2,dog1:1
    [dog1 release];//dog1:0
    [dog2 release];//dog2:1
    [person release];//dog2;
}

- (void)test3{
    Dog *dog = [[Dog alloc]init];//dog:1
    Person *person = [[Person alloc]init];
    [person setDog:dog];//dog:2
    [dog release];//dog:1
    [person setDog:dog];
    [person setDog:dog];
    [person setDog:dog];
    [person setDog:dog];
    [person setDog:dog];
    [person release];//dog:0
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self test1];
    
//    self.data = [[NSMutableArray alloc]init];
//    [self.data release];
    //等价于上面
    self.data = [[[NSMutableArray alloc]init] autorelease];
    //等价于上面
//    self.data = [NSMutableArray array];
    
    Person *person = [Person person];
}


- (void)dealloc{
    self.data = nil;
    NSLog(@"%s",__func__);
    [super dealloc];
}

@end
