//
//  UIView+AddThemeMode.h
//  SinoNews
//
//  Created by Michael on 2018/7/12.
//  Copyright © 2018年 Sino. All rights reserved.
//
//专门处理视图的主题

#import <UIKit/UIKit.h>

@interface UIView (AddThemeMode)

//添加背景颜色主题
-(void)addBakcgroundColorTheme;

//添加标题颜色主题
-(void)addTitleColorTheme;

//添加内容颜色主题
-(void)addContentColorTheme;

//添加按钮label字体颜色主题
-(void)addButtonTextColorTheme;

//添加按钮normal模式的图片
-(void)addButtonNormalImage:(NSString *)identify;

//添加按钮selected模式的图片
-(void)addButtonSelectedImage:(NSString *)identify;



@end
