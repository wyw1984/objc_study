//
//  SLPerson.h
//  11.Runtime
//  w
//  Created by songlin on 2019/6/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPerson : NSObject


//@property (assign, nonatomic, getter=isTall) BOOL tall;
//@property (assign, nonatomic, getter=isRich) BOOL rich;
//@property (assign, nonatomic, getter=isHansome) BOOL handsome;


- (void)setTall:(BOOL)tall;
- (void)setRich:(BOOL)rich;
- (void)setHandsome:(BOOL)handsome;


- (BOOL)isTall;
- (BOOL)isRich;
- (BOOL)isHandsome;

- (void)setWhite:(BOOL)white;
- (void)setFull:(BOOL)full;
- (void)setBeautiful:(BOOL)beautiful;


- (BOOL)isWhite;
- (BOOL)isFull;
- (BOOL)isBeautiful;

//共同体
- (void)setTall1:(BOOL)tall1;
- (void)setRich1:(BOOL)rich1;
- (void)setHandsome1:(BOOL)handsome1;
- (void)setThin:(BOOL)thin;


- (BOOL)isTall1;
- (BOOL)isRich1;
- (BOOL)isHandsome1;
- (BOOL)isThin;

@end

NS_ASSUME_NONNULL_END
