//
//  SelectCommentPageView.h
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//
//选择评论分页的弹窗视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCommentPageView : UIView

@property (nonatomic,copy) void(^clickBlock)(NSInteger selectIndex);

/**
 弹出方法

 @param total 总数
 @param selectedIndex 默认选定的下标
 */
-(void)showAllNum:(NSInteger)total defaultSelect:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
