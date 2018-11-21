//
//  UIView+AddGradientRamp.h
//  SinoNews
//
//  Created by Michael on 2018/11/21.
//  Copyright © 2018 Sino. All rights reserved.
//
//给视图添加渐变色

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AddGradientRamp)
//水平方向添加渐变色
-(void)addHGradientLayer:(NSArray<UIColor*>*)colors;

@end

NS_ASSUME_NONNULL_END
