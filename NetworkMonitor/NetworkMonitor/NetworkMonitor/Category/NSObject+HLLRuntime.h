//
//  NSObject+HLLRuntime.h
//  Network
//
//  Created by fengsl on 2020/8/25.
//  Copyright © 2020 fengsl. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <objc/runtime.h>



@interface NSObject (HLLRuntime)

/**
 Swizzle class method.

 @param oriSel Original selector.
 @param swiSel Swizzled selector.
 */
+ (void)HLL_swizzleClassMethodWithOriginSel:(SEL)oriSel
                               swizzledSel:(SEL)swiSel;

/**
 Swizzle instance method.

 @param oriSel Original selector.
 @param swiSel Swizzled selector.
 */
+ (void)HLL_swizzleInstanceMethodWithOriginSel:(SEL)oriSel
                                  swizzledSel:(SEL)swiSel;

/// Swizzle method.
/// @param method1 Method1
/// @param method2 Method2
+ (void)HLL_swizzleMethod:(Method)method1 anotherMethod:(Method)method2;

/**
 Get all property names.

 @return Property name array.
 */
+ (NSArray *)HLL_getPropertyNames;

/**
Get all property names.

@return Property name array.
*/
- (NSArray *)HLL_getPropertyNames;

/**
 Get all instance method names;
 */
+ (NSArray *)HLL_getInstanceMethodNames;

/**
Get all class method names;
*/
+ (NSArray *)HLL_getClassMethodNames;



- (NSArray *)HLL_getClassIvars;

+ (NSArray *)HLL_getClassIvars;

/**
 Add string property.

 @param string String value.
 @param key Key.
 */
- (void)HLL_setStringProperty:(NSString *_Nullable)string key:(const void *)key;

/**
 Get string property.

 @param key Key.
 @return String value.
 */
- (NSString *_Nullable)HLL_getStringProperty:(const void *)key;

/**
 Add CGFloat property.
 
 @param number CGFloat value.
 @param key Key.
 */
- (void)HLL_setCGFloatProperty:(CGFloat)number key:(const void *)key;

/**
 Get CGFloat property.
 
 @param key Key.
 @return CGFloat value.
 */
- (CGFloat)HLL_getCGFloatProperty:(const void *)key;




@end

