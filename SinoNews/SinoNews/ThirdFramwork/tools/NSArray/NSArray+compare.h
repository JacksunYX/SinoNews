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
 比较两个包含字符串的数组中元素是否完全相等（包括元素和位置）

 @param arr1 数组1
 @param arr2 数组2
 @return 比较结果
 */
+ (BOOL)compareArr:(NSArray *)arr1 andArr2:(NSArray *)arr2;

@end
