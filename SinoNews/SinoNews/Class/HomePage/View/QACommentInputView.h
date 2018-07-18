//
//  QACommentInputView.h
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义问答输入框

#import <UIKit/UIKit.h>

@interface QACommentInputView : UIView


/**
 显示

 @param block 点击发送后的回调
 */
+(void)showAndSendHandle:(void(^)(NSString *inputText))block;

@end
