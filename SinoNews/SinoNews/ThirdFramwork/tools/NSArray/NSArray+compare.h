//
//  NSArray+compare.h
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (compare)

/**
 比较2个数组里的元素是否完全相同

 @param array1 数组1
 @param array2 数组2
 @return 是否相等
 */
+(BOOL)compareArr:(NSArray *)array1 another:(NSArray *)array2;

@end
