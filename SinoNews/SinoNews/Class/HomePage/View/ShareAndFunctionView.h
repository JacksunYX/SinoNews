//
//  ShareAndFunctionView.h
//  SinoNews
//
//  Created by Michael on 2018/6/27.
//  Copyright © 2018年 Sino. All rights reserved.
//
//基于一个三方库的封装，定制的分享和功能性的弹出视图

#import <UIKit/UIKit.h>

@interface ShareAndFunctionView : UIView

/**
 显示
 */
+(void)showWithCollect:(BOOL)collect returnBlock:(void(^)(NSInteger section,NSInteger row, MGShareToPlateform sharePlateform)) clickBlock;

@end
