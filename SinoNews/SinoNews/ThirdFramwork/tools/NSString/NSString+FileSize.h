//
//  NSString+FileSize.h
//  SinoNews
//
//  Created by Michael on 2018/6/22.
//  Copyright © 2018年 Sino. All rights reserved.
//
//文件大小计算，清楚缓存

#import <Foundation/Foundation.h>

@interface NSString (FileSize)

/**
 默认获取缓存文件大小

 @return 文件大小
 */
+ (NSString *)getCacheSize;

/**
 默认清楚缓存

 @return 是否清除
 */
+ (BOOL)clearCache;

/**
 根据路径获取文件大小

 @param path 路径
 @return 文件大小
 */
+ (NSString *)getCacheSizeWithPath:(NSString *)path;

/**
 根据路径清楚缓存

 @param path 路径
 @return 是否清除
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

@end
