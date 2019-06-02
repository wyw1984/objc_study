//
//  main.m
//  10.Block初步认识
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPerson.h"

/*
 struct __block_impl {
 void *isa;
 int Flags;
 int Reserved;
 void *FuncPtr;
 };
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int age;
    __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int flags=0) : age(_age) {
        impl.isa = &_NSConcreteStackBlock;
        impl.Flags = flags;
        impl.FuncPtr = fp;
        Desc = desc;
    }
};
 //block 转化为函数
static void __main_block_func_0(struct __main_block_impl_0 *__cself, int a, int b) {
    int age = __cself->age; // bound by copy
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_sf_bp_0n89d4hg12g3zc2f8_08m0000gn_T_main_76078c_mi_0,age);
    NSLog((NSString *)&__NSConstantStringImpl__var_folders_sf_bp_0n89d4hg12g3zc2f8_08m0000gn_T_main_76078c_mi_1);
}
static struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(int argc, const char * argv[]) {
 //生成autoreleasepool
    { __AtAutoreleasePool __autoreleasepool;
        int age = 20;
 //初始化
        void (*block)(int,int) = ((void (*)(int, int))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA, age));
        调用函数并传参，第一个参数(__block_impl *)block代表传递第一个地址值，也就是结构体第一个元素地址，也就是结构体地址
        ((void (*)(__block_impl *, int, int))((__block_impl *)block)->FuncPtr)((__block_impl *)block, 10, 10);
    }
    return 0;
}
*/

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
    
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0 *Desc;
//    int age;
    struct __Block_byref_age_0 *age;

};

//0x102802f10
struct __Block_byref_age_0 {
    void *__isa;//8
    struct __Block_byref_age_0 *__forwarding;//8 0x102802f18
    int __flags;//4 0x102802f20
    int __size;//4 0x102802f24
    int age;//0x102800a28
};

//初步认识
void test1(){
    int age = 20;
    void (^block)(int,int) = ^(int a,int b){
        NSLog(@"this is a blcok!---%d",age);
        NSLog(@"this is a block");
    };
    
    //强制转换，在这里可以尝试打印出FuncPtr的值，然后通过always show disassembly 可以看到block的时候就是调用了函数地址
    //        struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block;
    
    block(10, 10);

}

//auto 变量
void (^block)(void);
void test2(){
    int age = 10;
    static int height = 10;
    block = ^{
        //age 的值捕获进来(capture)
        NSLog(@"age is %d,height is %d",age,height);
    };
    age = 20;
    height = 20;
    
}

//全局变量
int age_ = 10;
static int height_ = 10;
void (^block3)(void);
void test3(){
    static int salary = 100;
    block3 = ^{
        //age 的值捕获进来(capture)
        NSLog(@"age is %d,height is %d salary is %d",age_,height_,salary);
    };
    age_ = 20;
    height_ = 20;
    salary = 200;
    
}

//一切以运行时为准，有可能和clang不一样

void (^block4)(void);
void test4MRC()
{
    
    // NSStackBlock
    int age = 10;
    block4 = ^{
        NSLog(@"block4---------%d", age);
    };
        NSLog(@"block4%@",[block4 class]);

}

//模拟ARC
//void test4()
//{
//    
//    // NSStackBlock
//    int age = 10;
//    block4 = [^{
//        NSLog(@"block4---------%d", age);
//    } copy];
//    NSLog(@"block4%@",[block4 class]);
////    NSLog(@"block4%@",[[block4 class] superclass]);
////    NSLog(@"block4%@",[[[block4 class] superclass]superclass]);
////    NSLog(@"block4%@",[[[[block4 class] superclass]superclass]superclass]);
//    
//    //MRC模式下需要release，因为copy到堆中了
//    [block4 release];
//
//}
void test4ARC()
{
    // NSMallocBlock
    int age = 10;
    block4 = ^{
        NSLog(@"block4---------%d", age);
    };
    //    NSLog(@"block4%@",[block4 class]);
    //    NSLog(@"block4%@",[[block4 class] superclass]);
    //    NSLog(@"block4%@",[[[block4 class] superclass]superclass]);
    //    NSLog(@"block4%@",[[[[block4 class] superclass]superclass]superclass]);
    
}

void test5()
{
    // Global：没有访问auto变量
    void (^block5)(void) = ^{
        NSLog(@"block5---------");
    };
//    NSLog(@"block5%@",[block5 class]);
//    NSLog(@"block5%@",[[block5 class] superclass]);
//    NSLog(@"block5%@",[[[block5 class] superclass]superclass]);
//    NSLog(@"block5%@",[[[[block5 class] superclass]superclass]superclass]);
    // Stack：访问了auto变量 这里如果在ARC情况下，打印出来的是NSMallocBlokc，而MRC的情况下打印出来的是NSStackBlock，说明ARC帮我们做了一些额外的操作
    int age = 10;
    void (^block6)(void) = ^{
        NSLog(@"block6---------%d", age);
    };
//    NSLog(@"block6%@",[block6 class]);
//    NSLog(@"block6%@",[[block6 class] superclass]);
//    NSLog(@"block6%@",[[[block6 class] superclass]superclass]);
//    NSLog(@"block6%@",[[[[block6 class] superclass]superclass]superclass]);
//    NSLog(@"blockxxxs%@",[^{
//        NSLog(@"block6---------%d", age);
//    }class]);
//    NSLog(@"%p",block6);
//    NSLog(@"%p", [block6 copy]);
    
    //    NSLog(@"%@ %@", [block1 class], [block2 class]);
}

int age = 10;

typedef void (^SLBlock)(void);


SLBlock myBlock()
{
    int age1 = 10;
    return ^{
        NSLog(@"--------%d",age);
    };
}


void test6(){
    SLBlock slblock;
    {
        
        __block int age = 10;
        NSLog(@"block前%p",&age);
        slblock = [^{
            //                age = 20;
            NSLog(@"block 内age的值---------%d", age);
            NSLog(@"block内%p",&age);
        } copy];
        //这个时候访问栈上面的age的指针，发现和block内age的指针一样，说明栈上面的age->forwarding指针->age 找到的就是堆上面的age的变量的值，也就是说这个时候栈上面的forwarding指针指向堆上面的地址，堆上面的forwarding指向的是堆本身地址，所以c++源码之所以用val->forwarding->val 都能访问到正确的值
        NSLog(@"block外%p",&age);
        age = 30;
        slblock();
        NSLog(@"block 内age的值-------------：%d",age);
        
    }
}

void test7(){
    __block int age = 10;
    
    SLBlock block = ^{
        age = 20;
        NSLog(@"age is %d", age);
    };
    
    struct __main_block_impl_0 *blockImpl = (__bridge struct __main_block_impl_0 *)block;
    
    NSLog(@"blockImpl:%@",blockImpl);
    NSLog(@"%p", &age);

    
}

void test8(){
    SLPerson *person = [[SLPerson alloc]init];
    person.age = 10;
    __weak SLPerson *weakPerson = person;
    person.block = ^{
        NSLog(@"-------%d",weakPerson.age);
    };
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
//        test1();
//        test2();
//        block();
//        test3();
//        block3();
        
        //stack
//        test4MRC();
//        block4();
        //malloc
//        test4();
//        block4();

        
//        test5();
        
//        int a = 10;
//
//        NSLog(@"数据段：age %p", &age);
//        NSLog(@"栈：a %p", &a);
//        NSLog(@"堆：obj %p", [[NSObject alloc] init]);
//        NSLog(@"数据段：class %p", [MJPerson class]);
        
        //block copy 情况
        //1.作为返回参数
//        SLBlock block = myBlock();
//        block();
//        NSLog(@"%@",[block class]);
        
        
        //证明block 中的fowarding作用
//        test6();
        //证明age的地址是结构体的地址还是变量的地址
//        test7();
        
        //循环引用
        test8();
    }
    //和test8 一起使用
    //如果执行到这里,说明大括号执行完毕了，person对象应该是被释放的
    NSLog(@"测试循环引用");
    return 0;
}
