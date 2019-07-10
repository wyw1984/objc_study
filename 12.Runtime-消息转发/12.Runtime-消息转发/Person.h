//
//  Person.h
//  12.Runtime-消息转发
//
//  Created by fengsl on 2019/6/16.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

- (void)test;
+ (void)testClass;
- (void)eat:(NSString *)food;
- (void)driving;
- (int)driving:(int)time;

@end

NS_ASSUME_NONNULL_END
