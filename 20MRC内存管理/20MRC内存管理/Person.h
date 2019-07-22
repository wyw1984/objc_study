//
//  Person.h
//  20MRC内存管理
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    Dog *_dog;
    Car *_car;
    int _age;
}
- (void)setAge:(int)age;
- (int)age;
- (void)setDog:(Dog *)dog;
- (Dog*)dog;

- (void)setCar:(Car *)car;
-(Car *)car;


//@property (nonatomic, assign) int age;
//写成retain 修饰的时候，在MRC的情况下，就会自动生成了管理内存的模式
//@property (nonatomic, retain) Dog *dog;
//@property (nonatomic, retain) Car *car;
//
+ (instancetype)person;

@end

NS_ASSUME_NONNULL_END
