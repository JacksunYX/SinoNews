//
//  NSString+FileSize.m
//  SinoNews
//
//  Created by Michael on 2018/6/22.
//  Copyright © 2018年 Sino. All rights reserved.
//
/*
 //    Document文件：用来保存应由程序运行时生成的需要持久化的数据， iTunes会自动备份该目录
 NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
 
 //    Library文件夹：用来存储程序的默认设置和其他状态信息，iTunes也会自动备份该目录
 NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
 
 //    Library/Caches文件夹：
 NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
 
 //    Library/Preferences:用来存储用户的偏好设置，iOS的setting（设置）会在这个目录中查找应用程序的设置信息，iTunes会自动备份该目录，通常这个文件夹都是由系统进行维护的，不建议操作它
 NSString *librarypath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
 NSString *PreferencesPath = [librarypath stringByAppendingString:@"/Preferences"];
 
 //    tmp：保存应用程序的临时文件夹，使用完毕后，将相应的文件从这个目录中删除，如果空间不够，系统也可能会删除这个目录下的文件，iTunes不会同步这个文件夹，在iPhone重启的时候，该目录下的文件会被删除。
 NSString *temPath = NSTemporaryDirectory();
 */



#import "NSString+FileSize.h"

@implementation NSString (FileSize)

//默认获取常规缓存路径
+ (NSString *)getCacheSize
{
    NSString *libraryCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [self getCacheSizeWithPath:libraryCachePath];
}

//默认清楚缓存
+ (BOOL)clearCache
{
    return [self clearCacheWithFilePath:[self getCacheSize]];
}

+ (NSString *)getCacheSizeWithPath:(NSString *)path
{
    //获取当前路径下的所有文件：
    NSArray *subPathArr = [[NSFileManager defaultManager]subpathsAtPath:path];
    NSString *filePath = nil;
    NSInteger *totleSize = 0;
    for (NSString *subPath in subPathArr) {
        //拼接每一个子文件的路径：
        filePath = [path stringByAppendingString:subPath];
        //是否是文件夹：
        BOOL isDirectory = NO;
        //文件是否存在
        BOOL isExist = [[NSFileManager defaultManager]fileExistsAtPath:filePath isDirectory:&isDirectory];
        //文件过滤
        if (!isExist || isDirectory || [filePath containsString:@".DS"]) {
            continue;
        }
        //指定路径，获取这个路径属性
        long size = [[[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil]fileSize];
        totleSize += size;
    }
    long SDSize = [[SDImageCache sharedImageCache] getSize];
    totleSize += SDSize;
    //将文件夹大小转化为M/KB/B
    NSString *totleStr = @"";
    if ((long)totleSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM",(long)totleSize / (1000.00f * 1000.00f)];
    }else if ((long)totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fK",(long)totleSize / 1000.00f];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",(long)totleSize / 1.00f];
    }
    return totleStr;
}

// 根据路径删除路径下缓存
+ (BOOL)clearCacheWithFilePath:(NSString *)path
{
    
    //获取所有子路径
    
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = @"";
    NSError *error = nil;
    for (NSString *subPath in subPathArr) {
        filePath = [path stringByAppendingString:subPath];
        //删除子文件
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    return YES;
}


@end
