//
//  SLPerson.h
//  05.KVC&KVO
//
//  Created by fengsl on 2019/5/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject
{
    @public int _age;
}

@property (assign, nonatomic) int age;
@property (assign, nonatomic) double height;

@end

NS_ASSUME_NONNULL_END
