//
//  ViewController.m
//  05.KVC&KVO
//
//  Created by fengsl on 2019/5/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "ViewController.h"
#import "SLPerson.h"
#import <objc/runtime.h>


@interface ViewController ()
@property (strong, nonatomic) SLPerson *person1;
@property (strong, nonatomic) SLPerson *person2;

@end

@implementation ViewController

- (void)printMethodNamesOfClass:(Class)cls{
    unsigned int count;
    //获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    //存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    //遍历所有的方法
    for (int i = 0; i < count; i++) {
        //获得方法
        Method method = methodList[i];
        //获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        //拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    //释放
    free(methodList);
    //打印方法名
    NSLog(@"打印方法%@ %@",cls,methodNames);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.person1 = [[SLPerson alloc]init];
    self.person1.age = 1;
    self.person1.height = 11.0;
    
    self.person2 = [[SLPerson alloc]init];
    self.person2.age = 2;
    self.person2.height = 22.0;
    
    
  //证明1
//    NSLog(@"person1添加KVO监听之前-%@ %@",object_getClass(self.person1),object_getClass(self.person2));
    
    
    //证明2
//    NSLog(@"person1添加KVO监听之前-:%p %p %p %p",[self.person1 methodForSelector:@selector(setAge:)],[self.person2 methodForSelector:@selector(setAge:)],[self.person1 methodForSelector:@selector(setHeight:)],[self.person2 methodForSelector:@selector(setHeight:)]);
    //person1:setAge:0x10abd7740  person2:0x10abd7740 person1:setHeight:0x10abd7790 person2:setHeight:0x10abd7790
    
    
    //证明3
    
    //给person1 对象添加KVO监听
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person1 addObserver:self forKeyPath:@"age" options:options context:@"123"];
    [self.person1 addObserver:self forKeyPath:@"height" options:options context:@"456"];
   
    
    
    
    //证明1
    //    NSLog(@"person1添加KVO监听之后-%@ %@",object_getClass(self.person1),object_getClass(self.person2));

    //证明2
//    NSLog(@"person1添加KVO监听之后-:%p %p %p %p",[self.person1 methodForSelector:@selector(setAge:)],[self.person2 methodForSelector:@selector(setAge:)],[self.person1 methodForSelector:@selector(setHeight:)],[self.person2 methodForSelector:@selector(setHeight:)]);
    
    //person1:setAge:0x10af30cf2  person2:0x10abd7740 person1:setHeight:0x10abd7790 person2:setHeight:0x10abd7790
 //证明3
//    NSLog(@"%@ %@",object_getClass(self.person1),object_getClass(self.person2));
//    NSLog(@"%@ %@",[self.person1 class],[self.person2 class]);
    

    [self printMethodNamesOfClass:object_getClass(self.person1)];
    [self printMethodNamesOfClass:object_getClass(self.person2)];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    self.person1.age = 20;
//    self.person2.age = 20;
//
//    self.person1.height = 30.0;
//    self.person2.height = 40.0;
    
    //手动触发
//    [self.person1 willChangeValueForKey:@"age"];
//    [self.person1 didChangeValueForKey:@"age"];
    
    //更改成员变量
    self.person1->_age = 20;
}

- (void)dealloc{
    [self.person1 removeObserver:self forKeyPath:@"age"];
    [self.person1 removeObserver:self forKeyPath:@"height"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"监听到%@的%@属性值改变了--%@ - %@",object,keyPath,change,context);
}

@end
