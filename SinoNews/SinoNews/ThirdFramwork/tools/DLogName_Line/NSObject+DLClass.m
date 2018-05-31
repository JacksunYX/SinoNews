//
//  NSObject+DLClass.m
//  DLogFileNameLine
//
//  Created by 云宝 Dean on 16/4/8.
//  Copyright © 2016年 云宝 Dean. All rights reserved.
//

#import "NSObject+DLClass.h"

@implementation NSString (DLClass)
- (NSString *)nsLogFileName
{
    NSString *file = [[NSString alloc]initWithString:self];
    NSRange range = [file rangeOfString:@"/" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        file = [file substringFromIndex:range.location+1];
    }
    return file;
}

@end
