//
//  VideoAutoPlaySelectView.h
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//视频是否自动播放选择

#import <UIKit/UIKit.h>

typedef void(^selectBlock)(NSInteger selectIndex);

@interface VideoAutoPlaySelectView : UIView
/**
 显示在当前页面
 */
+(void)show:(selectBlock)handlBlock;

@property (nonatomic,copy)selectBlock handlBlock;

@end
