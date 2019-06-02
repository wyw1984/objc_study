//
//  SLPerson.h
//  10.Block初步认识
//
//  Created by fengsl on 2019/6/1.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SLBlock) (void);


NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject

@property (copy, nonatomic) SLBlock block;
@property (assign, nonatomic) int age;

- (void)test;

@end

NS_ASSUME_NONNULL_END
