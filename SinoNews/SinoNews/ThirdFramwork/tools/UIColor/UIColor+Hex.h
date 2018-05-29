//
//  UIColor+Hex.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#define WhiteColor      [UIColor whiteColor]
#define BlackColor      [UIColor blackColor]
#define RedColor        [UIColor redColor]
#define YellowColor     [UIColor yellowColor]
#define BlueColor       [UIColor blueColor]
#define GreenColor      [UIColor greenColor]
#define GrayColor       [UIColor grayColor]
#define PurpleColor     [UIColor purpleColor]
#define DarkGrayColor   [UIColor darkGrayColor]
#define LightGrayColor  [UIColor lightGrayColor]
#define OrangeColor     [UIColor orangeColor]
#define BrownColor      [UIColor brownColor]
#define MagentaColor    [UIColor magentaColor]
#define CyanColor       [UIColor cyanColor]
#define ClearColor      [UIColor clearColor]

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
