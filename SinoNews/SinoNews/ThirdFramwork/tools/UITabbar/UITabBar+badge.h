//
//  UITabBar+badge.h
//  SinoNews
//
//  Created by Michael on 2018/9/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
