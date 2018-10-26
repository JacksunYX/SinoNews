//
//  UIButton+ImageTitleSpacing.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

#pragma mark ---- 修改文字
//修改文字
-(void)setBtnFont:(UIFont *)font;

//普通状态下的文字
-(void)setNormalTitle:(NSString *)title;

//选中状态下的文字
-(void)setSelectedTitle:(NSString *)title;

//高亮状态下的文字
-(void)setHighLightTitle:(NSString *)title;

//设置普通状态下的富文本文字
-(void)setNormalAttributedTitle:(NSAttributedString *)title;

//设置选中状态下的富文本文字
-(void)setSelectedAttributedTitle:(NSAttributedString *)title;

//设置高亮状态下的富文本文字
-(void)setHighLightAttributedTitle:(NSAttributedString *)title;

//普通状态下的文字颜色
-(void)setNormalTitleColor:(UIColor *)color;

//选中状态下的文字
-(void)setSelectedTitleColor:(UIColor *)color;

//高亮状态下的文字
-(void)setHighLightTitleColor:(UIColor *)color;

#pragma mark ---- 修改图片
//普通状态下的图片
-(void)setNormalImage:(UIImage *)image;

//选中状态下的图片
-(void)setSelectedImage:(UIImage *)image;

//高亮状态下的图片
-(void)setHighLightImage:(UIImage *)image;

//普通状态下的背景图片
-(void)setNormalBackgroundImage:(UIImage *)image;

//选中状态下的背景图片
-(void)setSelectedBackgroundImage:(UIImage *)image;

//高亮状态下的背景图片
-(void)setHighLightBackgroundImage:(UIImage *)image;


@end
