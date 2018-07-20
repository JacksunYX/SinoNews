//
//  QACommentInputView.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "QACommentInputView.h"

@implementation QACommentInputView

static CGFloat anumationTime = 0.3;

+(void)showAndSendHandle:(void(^)(NSString *inputText))block
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //下方视图
    CGFloat bottomViewHeight = 180;
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = WhiteColor;
    
    [backView addSubview:bottomView];
//    bottomView.sd_layout
//    .leftEqualToView(backView)
//    .rightEqualToView(backView)
//    .bottomSpaceToView(backView, -bottomViewHeight)
//    .heightIs(bottomViewHeight)
//    ;
//    [bottomView updateLayout];
    bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
    
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
//        bottomView.sd_resetLayout
//        .leftEqualToView(backView)
//        .rightEqualToView(backView)
//        .bottomSpaceToView(backView, 0)
//        .heightIs(bottomViewHeight)
//        ;
        bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - bottomViewHeight, ScreenW, bottomViewHeight);
        
    }];
    
    //点击移除手势
    @weakify(backView)
    @weakify(bottomView)
    [backView whenTap:^{
        @strongify(backView)
        @strongify(bottomView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
//            bottomView.sd_layout
//            .leftEqualToView(backView)
//            .rightEqualToView(backView)
//            .bottomSpaceToView(backView, -bottomViewHeight)
//            .heightIs(bottomViewHeight)
//            ;
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //添加输入框和其他控件
    JHTextView *textView = [JHTextView new];
    
//    textView.limitLength = 10;
    textView.placeholder = @"写点什么吧";
    textView.backgroundColor = RGBA(50, 50, 50, 0.1);
    
    
    UIButton *sendBtn = [UIButton new];
    [bottomView sd_addSubviews:@[
                                 sendBtn,
                                 textView,
                                 ]];
    sendBtn.sd_layout
    .rightSpaceToView(bottomView, 10)
    .bottomSpaceToView(bottomView, 10)
    .widthIs(80)
    .heightIs(40)
    ;
    [sendBtn setSd_cornerRadius:@20];
    [sendBtn setNormalTitle:@"发送"];
    [sendBtn setBtnFont:PFFontL(14)];
    [sendBtn setNormalTitleColor:GrayColor];
    sendBtn.backgroundColor = RGBA(50, 50, 50, 0.1);
    
    textView.sd_layout
    .topSpaceToView(bottomView, 10)
    .leftSpaceToView(bottomView, 10)
    .rightSpaceToView(bottomView, 10)
    .bottomSpaceToView(sendBtn, 10)
    ;
    
    //发送按钮回调
    @weakify(textView)
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(textView)
        if (block) {
            block(textView.text);
        }
        
        @strongify(backView)
        @strongify(bottomView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
            bottomView.sd_layout
            .leftEqualToView(backView)
            .rightEqualToView(backView)
            .bottomSpaceToView(backView, -bottomViewHeight)
            .heightIs(bottomViewHeight)
            ;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //添加监听
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(bottomView)
        NSDictionary *info = x.userInfo;
        CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:anumationTime animations:^{
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - keyboardSize.height - bottomViewHeight + BOTTOM_MARGIN, ScreenW, bottomViewHeight);
        }];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        [UIView animateWithDuration:anumationTime animations:^{
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - bottomViewHeight, ScreenW, bottomViewHeight);
        }];
    }];
}


@end
