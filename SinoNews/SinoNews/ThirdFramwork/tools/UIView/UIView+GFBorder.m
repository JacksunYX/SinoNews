//
//  UIView+Border.m
//  UIViewCorner&Border
//
//  Created by 厉国辉 on 2017/5/4.
//  Copyright © 2017年 GofeyLee. All rights reserved.
//

#import "UIView+GFBorder.h"

@implementation UIView (GFBorder)
static int tag = 1238129;
- (void)addBorderTo:(BorderDirectionType)borderType borderColor:(UIColor*) color
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == tag) {
            [subView removeFromSuperview];
            break;
        }
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = color;
    lineView.tag = tag;
    [self addSubview:lineView];
    
    switch (borderType) {
        case BorderTypeTop:
            lineView.frame = CGRectMake(0, 0, width, 1);
            break;
        case BorderTypeLeft:
            lineView.frame = CGRectMake(0, 0, 1, height);
            break;
        case BorderTypeRight:
            lineView.frame = CGRectMake(width - 1, 0, 1, height);
            break;
        case BorderTypeBottom:
            lineView.frame = CGRectMake(0, height - 1, width, 1);
            break;
        default:
            break;
    }
    
}

- (void)addBorderTo:(BorderDirectionType)borderType borderSize:(CGSize)size borderColor:(UIColor*) color
{
    CGFloat layerWidth = self.layer.bounds.size.width;
    CGFloat layerheight = self.layer.bounds.size.height;
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CALayer *borderLayer = [CALayer layer];
    borderLayer.backgroundColor = color.CGColor;
    [self.layer addSublayer:borderLayer];
    switch (borderType) {
        case BorderTypeTop:
            borderLayer.frame = CGRectMake((layerWidth - width) / 2, 0, width, height);
            break;
        case BorderTypeLeft:
            borderLayer.frame = CGRectMake(0, (layerheight - height) / 2, width, height);
            break;
        case BorderTypeRight:
            borderLayer.frame = CGRectMake(layerWidth - width, (layerheight - height) / 2, width, height);
            break;
        case BorderTypeBottom:
            borderLayer.frame = CGRectMake((layerWidth - width) / 2, layerheight - height, width, height);
            break;
        default:
            break;
    }
    
    
}

//添加虚线框
-(void)addBorderLineOnView:(UIColor *)color
{
    CAShapeLayer *border = [CAShapeLayer layer];
    GGLog(@"bound:%@",NSStringFromCGRect(self.bounds));
    //虚线的颜色
    border.strokeColor = color.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = 0.5f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    [self.layer addSublayer:border];
    
}


@end
