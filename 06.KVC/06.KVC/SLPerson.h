//
//  SLPerson.h
//  06.KVC
//
//  Created by fengsl on 2019/5/4.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject
{
    @public
    int age;
    int isAge;
    int _isAge;
    int _age;
}

@end

NS_ASSUME_NONNULL_END
