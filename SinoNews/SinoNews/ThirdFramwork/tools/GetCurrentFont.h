//
//  GetCurrentFont.h
//  SinoNews
//
//  Created by Michael on 2018/7/12.
//  Copyright © 2018年 Sino. All rights reserved.
//
//获取当前设置的字体

#import <Foundation/Foundation.h>

@interface GetCurrentFont : NSObject

/**
 设置标题字体

 @return 返回当前要设置的字体
 */
+(UIFont *)titleFont;

/**
 设置内容字体

 @return 返回当前要设置的字体
 */
+(UIFont *)contentFont;

@end
