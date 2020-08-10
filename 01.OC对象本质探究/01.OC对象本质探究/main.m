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
struct Student_IMPL {
//    struct NSObject_IMPL NSObject_IVARS;
    Class isa;
    int _no;
    int _age;
};

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
    Student *stu = [[Student alloc]init];
    stu->_no = 4;
    stu->_age = 5;
    NSLog(@"%zd", class_getInstanceSize([Student class]));
    NSLog(@"%zd", malloc_size((__bridge const void *)stu));
    
    struct Student_IMPL *stuImpl = (__bridge struct Student_IMPL *)stu;
    NSLog(@"no is %d, age is %d", stuImpl->_no, stuImpl->_age);

}

void testStudentPerson(){

    Person *person = [[Person alloc] init];
    person->_age1 = 9;
    NSLog(@"person - %zd", class_getInstanceSize([Person class]));
    NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
    
    Student *stu = [[Student alloc] init];
    stu->_age1 = 9;
    stu->_no = 4;
    stu->_age = 5;
    NSLog(@"stu - %zd", class_getInstanceSize([Student class]));
    NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));
    
    
    NSLog(@"test");
}

//struct Person_IMPL {
//    struct NSObject_IMPL NSObject_IVARS;
//    int _age1;
//};

void testInstance(){
    Person *object1 = [[Person alloc]init];
    object1->_age1 = 8;
    Person *object2 = [[Person alloc]init];
    object2->_age1 = 9;
    NSLog(@"object1:%@------object2:%@",object1,object2);
}

void testClass(){
    NSObject *object1 = [[NSObject alloc]init];
    NSObject *object2 = [[NSObject alloc]init];
    Class objectClass1 = [object1 class];
    Class objectClass2 = [object2 class];
    Class objectClass3 = [NSObject class];
    Class objectClass4 = object_getClass(object1);//Runtime API
    Class objectClass5 = object_getClass(object2);//RunTime API
    
    NSLog(@"object1:%@",object1);
    NSLog(@"object2:%@",object2);
    NSLog(@"objectClass1:%p",objectClass1);
    NSLog(@"objectClass2:%p",objectClass2);
    NSLog(@"objectClass3:%p",objectClass3);
    NSLog(@"objectClass4:%p",objectClass4);
    NSLog(@"objectClass5:%p",objectClass5);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testStudent();
        testStudentPerson();
    }
    return 0;
}
