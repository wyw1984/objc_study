//
//  main.m
//  02.对象方法实例方法
//
//  Created by fengsl on 2019/4/29.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SLPerson : NSObject<NSCopying>
{
    @public
    int _age;
}
@property (nonatomic, assign) int no;
- (void)personInstanceMethod;
+ (void)personClassMethod;

@end


@implementation SLPerson

- (void)test{
    
}

- (void)personInstanceMethod{
    
}
+ (void)personClassMethod{
    
}

- (id)copyWithZone:(NSZone *)zone{
    return nil;
}
@end


@interface SLStudent : SLPerson<NSCoding>
{
    @public
    int _weight;
}
@property (nonatomic, assign) int height;
- (void)studentInstanceMethod;
+ (void)studentClassMethod;
@end

@implementation SLStudent

- (void)test{
    
}

- (void)studentInstanceMethod{
    
}

+ (void)studentClassMethod{
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
}

@end

//模拟源码的类结构,因为obj_class继承obj_object,而obj_object 里面含有Class isa指针，这里直接就拿过来，所以就没有需要继承
struct sl_obj_class{
    Class isa;
    Class superclass;
};



//p/x (long)person->isa

//源码objc-object.h 可以看到isa指针在2.0之后需要 & ISA_MASK
/*
 inline Class
 objc_object::ISA()
 {
 assert(!isTaggedPointer());
 #if SUPPORT_INDEXED_ISA
 if (isa.nonpointer) {
 uintptr_t slot = isa.indexcls;
 return classForIndex((unsigned)slot);
 }
 return (Class)isa.bits;
 #else
 return (Class)(isa.bits & ISA_MASK);
 #endif
 }

 */

//objc-private.h
/*
 真机设备
# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL//isa类指针
#   define ISA_MAGIC_MASK  0x000003f000000001ULL//ISA_MAGIC_MASK 和 ISA_MASK 分别是
#   define ISA_MAGIC_VALUE 0x000001a000000001ULL
电脑或者模拟器
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
#   define ISA_MAGIC_MASK  0x001f800000000001ULL
#   define ISA_MAGIC_VALUE 0x001d800000000001ULL
 */

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        //?两者为什么不相等呢，是因为在2.0之后，isa指针需要&ISA_MASK才相同
        //SLPerson 类对象的地址是0x00000001000012a0
        //SLPerson 类对象的isa是0x001d8001000012a1
        
        //最终结果：0x001d8001000012a1 & 0x00007ffffffffff8ULL = 0x00000001000012a0
        
        
        //SLPerson 元类对象地址是
        
        SLPerson *person = [[SLPerson alloc]init];
        Class personClass = [SLPerson class];
        
        //p/x (long)personClass->isa
   // error: member reference base type 'Class' is not a structure or union
        //因为这里我们没有办法通过命令打印出类对象的isa值，所以这里我们需要模拟class的结构体
        
        //元类对象的地址是0x0000000100001278
        //类对象的isa地址是0x001d800100001279 p/x 0x001d800100001279 & 0x00007ffffffffff8ULL
//        (unsigned long long) $3 = 0x0000000100001278 也就是等于上面元类对象的地址
        
        Class personMetaClass = object_getClass(personClass);
       
        struct sl_obj_class *personClass1 = (__bridge struct sl_obj_class *)([SLPerson class]);
        struct sl_obj_class *studentClass1 = (__bridge struct sl_obj_class *)([SLStudent class]);
        
        NSLog(@"证明isa指向");
    }
    return 0;
}
