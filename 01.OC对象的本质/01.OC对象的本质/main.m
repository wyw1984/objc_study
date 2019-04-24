//
//  main.m
//  01.OC对象的本质
//
//  Created by fengsl on 2019/4/23.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

// NSObject Implementation
struct NSObject_IMPL {
    Class isa; // 8个字节
};

void testObj(){
    // insert code here...
    NSObject *obj = [[NSObject alloc]init];
    
    //获得NSObject实例对象的成员变量所占用的大小
    //       要使用runtime的方法 class_getInstanceSize，需要导入runtime.h头文件
    NSLog(@"%zd",class_getInstanceSize([NSObject class]));
    
    //获得obj指针所指向内存的大小
    //        malloc_size 这个方法需要引入头文件malloc.h
    NSLog(@"%zd",malloc_size((__bridge const void *)obj));
    
    //当然上面的打印输出代码在不同的平台有可能不一样
}


//struct Person_IMPL {
//    struct NSObject_IMPL NSObject_IVARS; // 8
//    int _age; // 4
//}; // 16 内存对齐：结构体的大小必须是最大成员大小的倍数
//
//struct Student_IMPL {
//    struct Person_IMPL Person_IVARS; // 16
//    int _no; // 4
//}; // 16

@interface Person : NSObject
{
@public
    int _age1;
}
//@property (nonatomic, assign) int height;
@end

@implementation Person

@end


//源码中可以得到mainStudent-arm64 这个是Student继承NSObject的时候
//struct Student_IMPL {
////    struct NSObject_IMPL NSObject_IVARS;
//    Class isa;
//    int _no;
//    int _age;
//};

//源码中可以得到mainStudentExtentPerson-arm64 这个是Student继承Person的时候
//struct Student_IMPL {
//    struct Person_IMPL Person_IVARS;
//    int _no;
//    int _age;
//};

//struct Person_IMPL {
//    struct NSObject_IMPL NSObject_IVARS;
//    int _age1;
//};

//struct Student_IMPL {
//    Class isa;
//    int _age1;
//    int _no;
//    int _age;
//};  //32
@interface Student : Person
{
    @public
    int _no;
    int _age;
//    int _obj;
//    int _height;
    
}

@end

@implementation Student

@end


void testStudent(){
//    Student *stu = [[Student alloc]init];
//    stu->_no = 4;
//    stu->_age = 5;
//    NSLog(@"%zd", class_getInstanceSize([Student class]));
//    NSLog(@"%zd", malloc_size((__bridge const void *)stu));
    
//    struct Student_IMPL *stuImpl = (__bridge struct Student_IMPL *)stu;
//    NSLog(@"no is %d, age is %d", stuImpl->_no, stuImpl->_age);

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
//
//        Person *person = [[Person alloc] init];
//        person->_age1 = 9;
//        NSLog(@"person - %zd", class_getInstanceSize([Person class]));
//        NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
        
        Student *stu = [[Student alloc] init];
        stu->_age1 = 9;
        stu->_no = 4;
        stu->_age = 5;
        NSLog(@"stu - %zd", class_getInstanceSize([Student class]));
        NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));


        NSLog(@"test");
}
    return 0;
}
