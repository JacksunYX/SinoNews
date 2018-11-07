//
//  ReplyThePostPopView.h
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//
//回复帖子以及帖子的回复

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReplyThePostPopView : UIView


/**
 弹出回复界面

 @param data 设置参数
 @param finishBlock 完成后的回调
 @param cancelBlock 取消后的回调
 */
-(void)showWithData:(NSDictionary *)data finishInputHandle:(void(^)(NSDictionary *inputData))finishBlock cancelHandle:(void(^)(NSDictionary *cancelData))cancelBlock;

@end

NS_ASSUME_NONNULL_END
