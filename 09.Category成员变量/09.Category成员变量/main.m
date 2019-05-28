//
//  main.m
//  09.Category成员变量
//
//  Created by fengsl on 2019/5/5.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPerson.h"
#import "SLPerson+Test.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        SLPerson *person = [[SLPerson alloc]init];
        person.weight = 100;
        person.name = @"forest";
        NSLog(@"weight:%d",person.weight);
        NSLog(@"name:%@",person.name);
        
    }
    return 0;
}
