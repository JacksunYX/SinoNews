//
//  YXHeader.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#define IPHONE_X (([[UIScreen mainScreen] bounds].size.height == 812) && ([[UIScreen mainScreen] bounds].size.width == 375))
#define HEIGHT_Adaptation (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)
#define NAVI_HEIGHT (IPHONE_X ? 88 : 64)
#define BOTTOM_MARGIN (IPHONE_X ? 34 : 0)
#define StatusBarHeight (20)

#define TAB_HEIGHT (IPHONE_X ? 83 : 49)
#define ScaleWidth(width) width * WIDTH_SCALE
#define ScaleHeight(height) height * HEIGHT_SCALE
#define WIDTH_SCALE (([UIScreen mainScreen].bounds.size.width)/375.0)

#define HEIGHT_SCALE (IPHONE_X ? ([UIScreen mainScreen].bounds.size.height)/812 : ([UIScreen mainScreen].bounds.size.height)/667)

#define kDefaultBGColor [UIColor colorWithHexString:@"efefef"]
#define kColor333 [UIColor colorWithHexString:@"333333"]
#define kColor666 [UIColor colorWithHexString:@"666666"]
#define kColor999 [UIColor colorWithHexString:@"999999"]
#define kColord40 [UIColor colorWithHexString:@"d40000"]






#import <Foundation/Foundation.h>

@interface YXHeader : NSObject

+ (BOOL)checkLogin;
//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin;


@end
