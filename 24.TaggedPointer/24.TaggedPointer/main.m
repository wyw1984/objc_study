//
//  main.m
//  24.TaggedPointer
//
//  Created by fengsl on 2020/2/15.
//  Copyright © 2020 NeonChange. All rights reserved.
//

#import <Foundation/Foundation.h>

//https://www.jianshu.com/p/f43214713f44
//taggedPointer 获取值的时候是通过将指针和一些相关值经过位运算得到的
BOOL isTaggedPointer(id pointer)
{
    return (long)(__bridge void *)pointer & 1;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        NSNumber *number = [NSNumber numberWithInt:10];
//        NSNumber *number = @(10);
        
        NSNumber *number1 = @4;
//        NSNumber *number2 = @5;
//        NSNumber *number3 = @(0xFFFFFFFFFFFFFFF);
        
     
        
//        NSLog(@"%d %d %d", isTaggedPointer(number1), isTaggedPointer(number2), isTaggedPointer(number3));
//        NSLog(@"%p %p %p", number1, number2, number3);
        
        
         [number1 intValue];
        
//        NSString *str1 = [NSString stringWithFormat:@"sfsfsfsfsffsfsfs"];
//        NSString *str2 = [NSString stringWithFormat:@"abc"];
//        NSLog(@"str1:%p----str2:%p",str1,str2);
    }
    return 0;
}
