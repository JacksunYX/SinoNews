//
//  NSString+Time.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)
//获取当前时间
+(NSString *)currentDateStr;

//获取当前时间戳
+(NSString *)currentTimeStr;

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+(NSString *)getDateStringWithTimeStr:(NSString *)str;

//字符串转时间戳 如：2017-4-10 17:15:10
+(NSString *)getTimeStrWithString:(NSString *)str;

@end
