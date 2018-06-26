//
//  NSString+AttText.h
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//
//富文本xiangg 

#import <Foundation/Foundation.h>

@interface NSString (AttText)

/**
 传入拼接字符串，并改变后面的字符串样式

 @param str1 字符串1
 @param str2 字符串2
 @param font 字符串2要修改的字体
 @param color 字符串2要修改的文字颜色
 @param tab 拼接时是否换行
 @return 返回拼接样式后的富文本
 */
+(NSMutableAttributedString *)leadString:(NSString *)str1 tailString:(NSString *)str2 font:(UIFont *)font color:(UIColor *)color lineBreak:(BOOL)tab;

@end
