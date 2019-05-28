//
//  SLPerson.h
//  09.Category成员变量
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject

//在类中声明一个age属性，相当于为这个类声明成员变量{int_age;} set方法：- (void)setAge:(int)age；get方法：- (int)age 的声明和实现，但是在分类中确没有生成实现方法和成员变量，接下来会通过模拟的方式生成，然后再通过关联属性实现并讲解
@property (assign, nonatomic) int age;


@end

NS_ASSUME_NONNULL_END
