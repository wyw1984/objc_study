//
//  main.m
//  23.内存对齐
//
//  Created by fengsl on 2020/2/8.
//  Copyright © 2020 NeonChange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

#pragma pack(1)

struct StructOne {
    char a;         //1字节
    double b;       //8字节
    int c;          //4字节
    short d;        //2字节
} MyStruct1;

struct StructTwo {
    double b;       //8字节
    char a;         //1字节
    short d;        //2字节
    int c;         //4字节
} MyStruct2;


// Shows the actual memory layout
//   struct StructOne {
//       char a;              // 1 byte
//       char _pad0[7];       //补齐7字节成为8(随后跟着的 double 大小)的倍数，原则一
//       double b;               // 8 bytes
//       int c;             // 4 bytes
//       short d;              // 2 byte
//       char _pad1[2];       // 补齐2字节让结构体的大小成为最大成员大小double（8字节）的倍数，原则三
//}

//https://www.lizenghai.com/archives/42335.html
//https://www.jianshu.com/p/3294668e2d8c
//?? 为什么相同的结构体，只是交换了变量 ab 在结构体中的顺序他们的大小就改变了呢？这就是“内存对齐”的现象。每个特定平台上的编译器都有自己的默认对齐系数程序员可以通过预编译命令#pragma pack(n)，n=1,2,4,8,16来改变这一系数，其中的n就是你要指定的“对齐系数”。
/*
 内存对齐的规则：
 1.数据成员对齐原则:struct 或 union(统称为结构体)的数据成员，第一个数据成员A放在偏移为0的地方，以后每个数据成员B的偏移为(#pragma pack(指定的数n)与该数据成员(也就是B)的自身长度较小那个数的整数倍，不够整数倍补齐
 2.数据成员为结构体：如果结构体的数据成员还为结构体，则该数据成员的自身长度为其内部最大元素的大小(struct a 里存有struct b，b里有char，int，double等元素，那么b自身长度为8)
 3.结构体的整体对齐规则，在数据成员按照上述第一步完成各自对齐之后，结构体本身也要进行对齐，对齐会将结构体的大小调整为(#pragma pack(指定的数n)与结构体中的最大长度的数据成员中较小那个的整数倍，不够的补齐
 
 
 已知（64位）char为1字节，double为8字节，int为4字节，short为2字节
 
 内存对齐原则其实可以简单理解为min(m,n)——m为当前开始的位置，n为所占位数。当m是n的整数倍时，条件满足；否则m位空余，m+1，继续min算法。
 
 如str1中的b，一开始为min(1,8)，不满足条件直至min(8,8)，所以它在第8位坐下了，占据8个格子
 
 如str2中的c，一开始为min(9,4)，不满足条件直至min(12,4)，所以它在第12位坐下了，占据4个格子
 
 如str3中的d，一开始为min(13,2)，不满足条件直至min(14,2)，所以它在第14位坐下了，占据2个格子
 

 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //23.内存对齐[2116:23907] 24---16--
       NSLog(@"%lu---%lu--", sizeof(MyStruct1), sizeof(MyStruct2));
        
        //验证实际内存分布图
//        long a = (long)&MyStruct1.a;
//        long b = (long)&MyStruct1.b ;
//        long c = (long)&MyStruct1.c;
//        long d = (long)&MyStruct1.d;
//        MyStruct1大小---24------
//        NSLog(@"MyStruct1大小---%lu------", sizeof(MyStruct1));
//        内存地址---4294975520,4294975528,4294975536,4294975540
        //char a + char _pad0[7] = 4294975520~4294975527 占用20~27字节 8
        //double b:4294975528~4294975535 占用28~35个字节 8
        //int c 4294975536~4294975539 占用36~39字节 4
        //short d + char_pad1[2]:4294975540 ~ 4294975543 占用40~43字节 4
//        NSLog(@"内存地址---%ld,%ld,%ld,%ld", a, b, c, d);
    }
    return 0;
}
