//
//  UIViewController+emptyView.h
//  SinoNews
//
//  Created by Michael on 2018/6/27.
//  Copyright © 2018年 Sino. All rights reserved.
//
//加载页

#import <UIKit/UIKit.h>

@interface UIViewController (emptyView)


/**
 显隐加载背景

 @param show 显示或者隐藏
 @param pageType 哪种界面
 */
-(void)showOrHideLoadView:(BOOL)show page:(NSInteger)pageType;

//显隐导航栏下方横线
-(void)showTopLine;
-(void)hiddenTopLine;

@end
