//
//  UIView+Gesture.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//封装手势快捷方法

#import <UIKit/UIKit.h>

@interface UIView (Gesture)


/**
 快捷创建并添加手势

 @param sel 手势封装的操作
 */
-(void)creatTapWithSelector:(SEL)sel;

/**
 画虚线

 @param lineView 画在哪个视图上
 @param lineLength 平均线长
 @param lineSpacing 虚线间隔
 @param lineColor 线条颜色
 */
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
