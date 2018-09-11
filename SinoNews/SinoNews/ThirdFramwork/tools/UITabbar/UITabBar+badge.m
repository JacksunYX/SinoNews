//
//  UITabBar+badge.m
//  SinoNews
//
//  Created by Michael on 2018/9/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UITabBar+badge.h"

#define TabbarItemNums 5.0    //tabbar的数量 如果是5个设置为5.0
#define BadgeSizeWH 8.0f      //badge宽高

@implementation UITabBar (badge)

//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = BadgeSizeWH/2;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    y = 5;
    badgeView.frame = CGRectMake(x, y, BadgeSizeWH, BadgeSizeWH);//圆形大小为10
    [self addSubview:badgeView];
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}

//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
