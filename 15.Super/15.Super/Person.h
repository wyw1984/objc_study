//
//  Person.h
//  15.Super
//
//  Created by fengsl on 2019/7/10.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (copy, nonatomic) NSString *name;

- (void)print;

@end

NS_ASSUME_NONNULL_END
