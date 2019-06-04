//
//  main.m
//  11.Runtime
//
//  Created by songlin on 2019/6/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLPerson.h"
#import <objc/runtime.h>

void testChar(){
    //char Test
    SLPerson *person = [[SLPerson alloc]init];
    person.rich = YES;
    person.tall = NO;
    person.handsome = NO;
    NSLog(@"tall:%d rich:%d hansome:%d", person.isTall, person.isRich, person.isHandsome);

    
}

void testStruct(){
    SLPerson *person = [[SLPerson alloc]init];
    person.white = YES;
    person.full = YES;
    person.beautiful = YES;
    
    NSLog(@"white:%d,full:%d,beautiful:%d", person.isWhite,person.isFull,person.isBeautiful);
}


void testUnion(){
    SLPerson *person = [[SLPerson alloc]init];
    person.thin = YES;
    person.rich1 = YES;
    person.handsome1 = YES;
    NSLog(@"thin:%d,rich1:%d,handsome1:%d", person.isThin,person.isRich1,person.isHandsome1);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
//        testChar();
        testStruct();
//        testUnion();
        
      
        
//        NSLog(@"%zd", class_getInstanceSize([SLPerson class]));

    }
    return 0;
}
