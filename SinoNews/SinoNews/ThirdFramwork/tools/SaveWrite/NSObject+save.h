//
//  NSObject+save.h
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//
//归档/解档

#import <Foundation/Foundation.h>

@interface NSObject (save)

/**
 写入对象到指定沙盒地址

 @param objc 需要被写入的对象
 @param fileName 写入地址
 */
+(void)writeToFileWithObject:(id)objc fileName:(NSString *)fileName;


/**
 根据指定文件名获取存储的对象,需要使用对应的类名来调用（不能直接使用NSObject调用）

 @param fileName 文件名
 */
+(id)getObjectWithfileName:(NSString *)fileName;


/**
 存储自定义对象到本地沙盒

 @param objc 自定义对象
 @param fileName 文件名
 @param key 存取对象对应的key
 */
+(void)saveCustomObject:(id)objc fileName:(NSString *)fileName key:(NSString *)key;


/**
 根据文件名和key获取之前写入沙盒的对象

 @param fileName 文件名
 @param key 存储时对应的key
 @return 返回解档后得到的对象
 */
+(id)getSaveObjectWithFileName:(NSString *)fileName key:(NSString *)key;


@end
