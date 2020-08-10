//
//  main.m
//  04.class结构模拟
//
//  Created by fengsl on 2019/4/29.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "SLClassInfo.h"
#import "SLClassInfoM.h"

@interface SLPerson : NSObject <NSCopying>
{
@public
    int _age;
}
@property (nonatomic, assign) int no;
- (void)personInstanceMethod;
+ (void)personClassMethod;
@end

@implementation SLPerson

- (void)test
{
    
}

- (void)personInstanceMethod
{
    
}
+ (void)personClassMethod
{
    
}
- (id)copyWithZone:(NSZone *)zone
{
    return nil;
}
@end

// SLStudent
@interface SLStudent : SLPerson <NSCoding>
{
@public
    int _weight;
}
@property (nonatomic, assign) int height;
- (void)studentInstanceMethod;
+ (void)studentClassMethod;
@end

@implementation SLStudent
- (void)test
{
    
}
- (void)studentInstanceMethod
{
    
}
+ (void)studentClassMethod
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
@end

void test1(){
    SLStudent *stu = [[SLStudent alloc] init];
    stu->_weight = 10;
    
    sl_objc_class *studentClass = (__bridge sl_objc_class *)([SLStudent class]);
    sl_objc_class *personClass = (__bridge sl_objc_class *)([SLPerson class]);
    
    class_rw_t *studentClassData = studentClass->data();
    class_rw_t *personClassData = personClass->data();
    
    class_rw_t *studentMetaClassData = studentClass->metaClass()->data();
    class_rw_t *personMetaClassData = personClass->metaClass()->data();
}

void test2(){
    SLStudent *stu = [[SLStudent alloc] init];
        //类对象
         Class objectClass1 = [stu class];
    Class metaClass1 = object_getClass(objectClass1);//Runtime API
    
    
       sl_objc_class *studentClass = (__bridge sl_objc_class *)([stu class]);
        sl_objc_class *metaClass = studentClass->metaClass();
    
        NSLog(@"class 类结构探险");
   
}
//
//void test3(){
//     SLStudent *stu = [[SLStudent alloc] init];
//    //类对象
//     Class objectClass1 = [stu class];
//      Class metaClass1 = object_getClass(objectClass1);//Runtime API
//
//
//   fsl_objc_class *studentClass = (__bridge fsl_objc_class *)([stu class]);
//    fsl_objc_class *metaClass = studentClass->metaClass();
//
//    NSLog(@"class 类结构探险");
//}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        test1();
      
        test2();
//        test3();
        
    }
    return 0;
}
