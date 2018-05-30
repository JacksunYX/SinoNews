//
//  NSArray+compare.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NSArray+compare.h"

@implementation NSArray (compare)
+(BOOL)compareArr:(NSArray *)array1 another:(NSArray *)array2
{
    BOOL equeal = NO;
    NSMutableSet *set1 = [NSMutableSet setWithArray:array1];
    NSMutableSet *set2 = [NSMutableSet setWithArray:array2];
    
    [set1 intersectSet:set2];  //取交集后 set1中为1
    
    if (set1.count < array1.count) {
        NSLog(@"两者不相等,说明arr1包含有arr2没有的数据");
        equeal = NO;
    }else if(set1.count == array1.count){
        if (set1.count == array2.count) {
            NSLog(@"array2 == array1 数组相等");
            equeal = YES;
        }else{
            NSLog(@"arr2大于arr1的数据");
            equeal = NO;
        }
    }else{
        NSLog(@"交集count > arr1的count，算法出错了了了了");
    }
    
    return equeal;
}
@end
