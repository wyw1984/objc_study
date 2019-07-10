//
//  main.m
//  12.Runtime-消息转发
//
//  Created by fengsl on 2019/6/16.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Car.h"
#import "CarPersonForward.h"





int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *person = [[Person alloc]init];
//        [person test];
//        [person eat:@"some"];
//        [Person testClass];
//        [person driving];
        
        CarPersonForward *forwardPerson = [[CarPersonForward alloc]init];
        NSLog(@"[person driving: 100] = %d",[forwardPerson driving:10]);;
    }
    return 0;
}
