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
 给视图添加点击事件

 @param block 点击事件回调
 */
-(void)whenTap:(void(^)(void))block;

/**
 画虚线

 @param lineView 画在哪个视图上
 @param lineLength 平均线长
 @param lineSpacing 虚线间隔
 @param lineColor 线条颜色
 */
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;


/**
 查找某个视图上是否存在某个类的视图

 @param className 类名
 @return 查找到的结果
 */
- (UIView*)subViewOfClassName:(NSString*)className;


@end
