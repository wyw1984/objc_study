//
//  Person.h
//  20.copy
//
//  Created by fengsl on 2019/7/21.
//  Copyright © 2019 fengsl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
//@property (copy, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *data;

@end

NS_ASSUME_NONNULL_END
