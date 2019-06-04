//
//  SLPerson.m
//  11.Runtime
//
//  Created by songlin on 2019/6/3.
//  Copyright © 2019 songlin. All rights reserved.
//

#import "SLPerson.h"

//& 可以用来取出特定的位
// 0000 0111
//&0000 0100
//-----------
//0000 0100

//掩码：一般用来按位与（&）运算的
//#define SLTallMask 1
//#define SLRichMask 2
//#define SLHandsomeMask 4

//#define SLTallMask 0b00000001
//#define SLRichMask 0b00000010
//#define SLHandsomeMask 0b00000100

#define SLThinMask (1<<3)
#define SLTallMask (1<<2)
#define SLRichMask (1<<1)
#define SLHandsomeMask (1<<0)



@interface SLPerson ()
{
    //二进制形式
    char _tallRichHansome;
    
    //位域形式
    struct {
        char white : 1;
        char full : 1;
        char beautiful : 1;
    } _whiteFullBeautiful;
    
    //共同体
    union {
        int bits;
        struct {
            char tall1:4;
            char rich1:4;
            char handsome1:4;
            char thin1:4;
        };
    }_tallRichHansome1;

}

@end

@implementation SLPerson


- (instancetype)init
{
    if (self = [super init]) {
        _tallRichHansome = 0b00000100;
    }
    return self;
}

- (void)setTall1:(BOOL)tall1{
    if (tall1) {
        _tallRichHansome1.bits |= SLTallMask;
    }else{
        _tallRichHansome1.bits &= ~SLTallMask;
    }
}
- (void)setRich1:(BOOL)rich1{
    if (rich1) {
        _tallRichHansome1.bits |= SLRichMask;
    }else{
        _tallRichHansome1.bits &= ~SLRichMask;
    }

}
- (void)setHandsome1:(BOOL)handsome1{
    if (handsome1) {
        _tallRichHansome1.bits |= SLHandsomeMask;
    }else{
        _tallRichHansome1.bits &= ~SLHandsomeMask;
    }

}
- (void)setThin:(BOOL)thin{
    if (thin) {
        _tallRichHansome1.bits |= SLThinMask;
    }else{
        _tallRichHansome1.bits &= ~SLThinMask;
    }

}


- (BOOL)isTall1{
    return !!(_tallRichHansome1.bits & SLTallMask);
}
- (BOOL)isRich1{
    return !!(_tallRichHansome1.bits & SLRichMask);
}
- (BOOL)isHandsome1{
    return !!(_tallRichHansome1.bits & SLHandsomeMask);
}
- (BOOL)isThin{
    return !!(_tallRichHansome1.bits & SLThinMask);
}


- (void)setTall:(BOOL)tall{
    if (tall) {
        _tallRichHansome |= SLTallMask;
    }else{
        _tallRichHansome &= ~SLTallMask;
    }
}
- (void)setRich:(BOOL)rich{
    if (rich) {
        _tallRichHansome |= SLRichMask;
    }else{
        _tallRichHansome &= ~SLRichMask;
    }
}
- (void)setHandsome:(BOOL)handsome{
    if (handsome) {
        _tallRichHansome |= SLHandsomeMask;
    }else{
        _tallRichHansome &= ~SLHandsomeMask;
    }
}


- (BOOL)isTall{
    return !!(_tallRichHansome & SLTallMask);
}
- (BOOL)isRich{
    return !!(_tallRichHansome & SLRichMask);
    
}
- (BOOL)isHandsome{
    return !!(_tallRichHansome & SLHandsomeMask);
}


- (void)setWhite:(BOOL)white{
    _whiteFullBeautiful.white = white;
}
- (void)setFull:(BOOL)full{
    _whiteFullBeautiful.full = full;
}
- (void)setBeautiful:(BOOL)beautiful{
    _whiteFullBeautiful.beautiful = beautiful;
}


- (BOOL)isWhite{
    return !!_whiteFullBeautiful.white;
}
- (BOOL)isFull{
    return !!_whiteFullBeautiful.full;
}
- (BOOL)isBeautiful{
   return  !!_whiteFullBeautiful.beautiful;
}


@end
