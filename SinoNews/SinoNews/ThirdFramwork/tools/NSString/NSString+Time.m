//
//  NSString+Time.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
//获取当前时间
+(NSString *)currentDateStr
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

//获取当前时间戳
+(NSString *)currentTimeStr
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.f", time];
    return timeString;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+(NSString *)getDateStringWithTimeStr:(NSString *)str
{
    NSTimeInterval time = [str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

//字符串转时间戳 如：2017-4-10 17:15:10
+(NSString *)getTimeStrWithString:(NSString *)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}

//加密方式
+(NSString *)encryptPlainText:(NSString *)plainText
{
    NSString *key = @"qazxrfvb";
    NSString *iv = @"0000000000000000";
    
    CryptLib *cryptoLib = [[CryptLib alloc] init];
    NSString *encryptedString = [cryptoLib encryptPlainText:plainText key:key iv:iv];
    GGLog(@"encryptedString :%@", encryptedString);
    return encryptedString;
}

//解密
+(NSString *)decryptCipherText:(NSString *)cipherText
{
    NSString *key = @"qazxrfvb";
    NSString *iv = @"0000000000000000";
    CryptLib *cryptoLib = [[CryptLib alloc] init];
    NSString *decryptString = [cryptoLib decryptCipherText:cipherText key:key iv:iv];
    GGLog(@"decryptString :%@", decryptString);
    return decryptString;
}

+(NSString *)encryptWithText:(NSString *)string
{
    NSString *key = @"qazxrfvb";
    CryptLib *cryptoLib = [[CryptLib alloc] init];
    NSString *encryptedString = [cryptoLib encryptPlainTextRandomIVWithPlainText:string key:key];
    GGLog(@"encryptedString :%@", encryptedString);
    return encryptedString;
}

+(NSString *)decryptWithText:(NSString *)string
{
    NSString *key = @"qazxrfvb";
    CryptLib *cryptoLib = [[CryptLib alloc] init];
    NSString *decryptString = [cryptoLib decryptCipherTextRandomIVWithCipherText:string key:key];
    GGLog(@"decryptString :%@", decryptString);
    return decryptString;
}


//获得某个时间段距当前时间的剩余时间
+(NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;
    NSString *hoursStr;
    NSString *minutesStr;
    NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
    //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return nil;
    }
//    if (days) {
        return [NSString stringWithFormat:@"%@天%@时%@分%@秒", dayStr,hoursStr, minutesStr,secondsStr];
//    }
//    return [NSString stringWithFormat:@"%@时%@分%@秒",hoursStr , minutesStr,secondsStr];
}

//获取过去某个时间与现在时间的时差
+(NSString *)getTimeDifferenceWith:(NSString *)Timestamp
{
    NSString *oldTimeStr = [self getDateStringWithTimeStr:Timestamp];
    NSString *currentTimeStr = [NSString getDateStringWithTimeStr:[self currentTimeStr]];
    
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:oldTimeStr];
    NSDate *date2 = [formatter dateFromString:currentTimeStr];
    
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSString *TimeDifference = [NSString stringWithFormat:@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second];
    TimeDifference = @"1秒前";
//    NSLog(@"%@",TimeDifference);
    if (cmps.year) {
        TimeDifference = [NSString stringWithFormat:@"%ld年前",cmps.year];
    }else if (cmps.month) {
        TimeDifference = [NSString stringWithFormat:@"%ld月前",cmps.month];
    }else if (cmps.day) {
        TimeDifference = [NSString stringWithFormat:@"%ld天前",cmps.day];
    }else if (cmps.hour) {
        TimeDifference = [NSString stringWithFormat:@"%ld小时前",cmps.hour];
    }else if (cmps.minute) {
        TimeDifference = [NSString stringWithFormat:@"%ld分钟前",cmps.minute];
    }else if (cmps.second) {
        TimeDifference = [NSString stringWithFormat:@"%ld秒钟前",cmps.second];
    }
    return TimeDifference;
}

@end
