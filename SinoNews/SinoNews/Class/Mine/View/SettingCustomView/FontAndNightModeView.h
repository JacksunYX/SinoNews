//
//  FontAndNightModeView.h
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//夜间模式和字体大小选择

#import <UIKit/UIKit.h>

@interface FontAndNightModeView : UIView

/**
 显示在当前页面
 */
+(void)showWithModelAndFont: (void(^)(BOOL open,NSInteger fontIndex))handlBlock;

@end
