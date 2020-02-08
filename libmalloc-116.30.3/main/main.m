//
//  main.m
//  main
//
//  Created by fengsl on 2020/2/8.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>

//定义Person类
@interface Person : NSObject
{
	//定义成员变量
	@public
	int _age1;
}

@end

@implementation Person

@end

//定义Student 类
@interface Student : Person
{
	@public
	int _no;
	int _age;
}

@end


@implementation Student

@end

void testStudentPerson(){

//    Person *person = [[Person alloc] init];
//    person->_age1 = 9;
//    NSLog(@"person - %zd", class_getInstanceSize([Person class]));
//    NSLog(@"person - %zd", malloc_size((__bridge const void *)person));
    
    Student *stu = [[Student alloc] init];
    stu->_age1 = 9;
    stu->_no = 4;
    stu->_age = 5;
    NSLog(@"stu - %zd", class_getInstanceSize([Student class]));
    NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));
    
    
    NSLog(@"test");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		testStudentPerson();
    }
    return 0;
}
