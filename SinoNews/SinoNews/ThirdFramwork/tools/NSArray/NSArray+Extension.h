//
//  NSArray+Extension.h
//  ICUnicodeDemo
//
//  Created by andy  on 15/8/8.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
- (NSString *)formatArray:(NSArray *)array formatString:(NSString *)formatString;

//kvc 获取所有key值
+ (NSArray *)getAllIvar:(id)object;

//获得所有属性
+ (NSArray *)getAllProperty:(id)object;

@end
