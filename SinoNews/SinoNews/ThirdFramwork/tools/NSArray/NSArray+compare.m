//
//  NSArray+compare.m
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NSArray+compare.h"

@implementation NSArray (compare)

//比较两个数组中是否有不同元素
- (BOOL)filterArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",arr1];
    //得到两个数组中不同的数据
    NSArray *reslutFilteredArray = [arr2 filteredArrayUsingPredicate:filterPredicate];
    if (reslutFilteredArray.count > 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)compareArr:(NSArray *)arr1 andArr2:(NSArray *)arr2 {
    if (arr1.count != arr2.count) { //两次数量不同，直接显示
        return NO;
    }else { //两个数量相同,比较字符串
        int hasSame =0;
        for (int i = 0; i < arr1.count; i++) {
            NSString *str1 = arr1[i];
            NSString *str2 = arr2[i];
            if ([str1 isEqualToString:str2]) {
                hasSame ++;
            }else{
                break;
            }
        }
        
        if (hasSame == arr1.count) { //两个元素相同
            return YES;
        }else {
            return NO;
        }
    }
}







@end
