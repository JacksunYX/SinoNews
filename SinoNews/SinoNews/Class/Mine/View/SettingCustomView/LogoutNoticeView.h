//
//  LogoutNoticeView.h
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义退出提示框

#import <UIKit/UIKit.h>

@interface LogoutNoticeView : UIView

/**
 显示在当前页面
 */
+(void)show:(void(^)(void))handlBlock;

@end
