//
//  NSObject+save.m
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//


#import "NSObject+save.h"

@implementation NSObject (save)

+(void)writeToFileWithObject:(id)objc fileName:(NSString *)fileName
{
    //找到路径进行存储
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //拼接最终路径
    NSString *savePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    //判断保存的数据类型，这里只做OC对象的数据类型存储
//    NSData *data;
//    if ([objc isKindOfClass:[UIImage class]]) {
//        //转为data
//        data = UIImageJPEGRepresentation((UIImage *)objc, 1);
//    }
//    if ([objc isKindOfClass:[NSString class]]) {
//        data = [(NSString *)objc dataUsingEncoding: NSUTF8StringEncoding];
//    }
//    if ([objc isKindOfClass:[NSDictionary class]]) {
//        data = [NSJSONSerialization dataWithJSONObject:(NSDictionary *)objc options:NSJSONWritingPrettyPrinted error:nil];
//    }
//    if ([objc isKindOfClass:[NSArray class]]) {
//
//    }
    
    if ([objc isKindOfClass:[NSString class]]) {
        [objc writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        [objc writeToFile:savePath atomically:YES];
    }
    GGLog(@"数据已写入沙盒");
    
}

+(id)getObjectWithfileName:(NSString *)fileName
{
    //找到路径进行存储
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //拼接最终路径
    NSString *savePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    id objc;
    NSString *className = NSStringFromClass(self);
    if ([className containsString:@"String"]) {
        objc = [NSString stringWithContentsOfFile:savePath encoding:NSUTF8StringEncoding error:nil];
    }else if ([className containsString:@"Dictionary"])
    {
        objc = [NSDictionary dictionaryWithContentsOfFile:savePath];
    }
    else if ([className containsString:@"Array"])
    {
        objc = [NSArray arrayWithContentsOfFile:savePath];
    }
    else if ([className containsString:@"Data"])
    {
        objc = [NSData dataWithContentsOfFile:savePath];
    }
//    GGLog(@"取出数据：%@",objc);
    return objc;
}

+(void)saveCustomObject:(id)objc fileName:(NSString *)fileName key:(NSString *)key
{
    //1.1找到路径进行存储
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //1.2拼接最终路径
    NSString *savePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    //2归档
    //2.1创建NSMutableData对象,用于初始化归档工具
    NSMutableData *data = [NSMutableData data];
    //2.2创建归档工具
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //2.3对要归档的对象进行归档
    [archiver encodeObject:objc forKey:key];
    //2.4结束归档
    [archiver finishEncoding];
    //3.将归档内容写入沙盒
    [data writeToFile:savePath atomically:YES];
    GGLog(@"对象已被写入沙盒");
}

+(id)getSaveObjectWithFileName:(NSString *)fileName key:(NSString *)key
{
    //1.1找到路径进行存储
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //1.2拼接最终路径
    NSString *savePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    // 2将要反归档的数据找出
    NSData *resultData = [NSData dataWithContentsOfFile:savePath];
    // 3.1创建解档工具
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:resultData];
    // 3.2对perosn对象进行解档
    id objc = [unarchiver decodeObjectForKey:key];
    // 3.3结束解档
    [unarchiver finishDecoding];
//    GGLog(@"取出对象：%@",[objc mj_keyValues]);
    return objc;
}




@end
