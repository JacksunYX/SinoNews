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
    CGFloat bottomViewHeight = 225;
    UIView *bottomView = [UIView new];
    [bottomView addBakcgroundColorTheme];
    
    [backView addSubview:bottomView];

    bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
    //只为上部分添加圆角
    [bottomView cornerWithRadius:8 direction:CornerDirectionTypeTop];
    
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - bottomViewHeight, ScreenW, bottomViewHeight);
    }];
    
    //点击移除手势
    @weakify(backView)
    @weakify(bottomView)
//    [backView whenTap:^{
//        @strongify(backView)
//        @strongify(bottomView)
//        [UIView animateWithDuration:anumationTime animations:^{
//            backView.alpha = 0;
//            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
//        } completion:^(BOOL finished) {
//            [backView removeFromSuperview];
//        }];
//    }];
    
    //添加输入框和其他控件
    JHTextView *textView = [JHTextView new];
    textView.limitLength = 200;
    textView.font = PFFontL(16);
    textView.placeholderLabel.font = PFFontL(16);
    [textView addBakcgroundColorTheme];
    if (UserGetBool(@"NightMode")) {
        textView.textColor = HexColor(#cfd3d6);
    }
//    textView.limitLength = 10;
    textView.placeholder = @"写点什么吧";
    
    UIButton *cancelBtn = [UIButton new];
    UIButton *sendBtn = [UIButton new];
    
    UIView *sepLine = [UIView new];
    sepLine.backgroundColor = CutLineColor;
    if (UserGetBool(@"NightMode")) {
        sepLine.backgroundColor = CutLineColorNight;
    }
    
    [bottomView sd_addSubviews:@[
                                 cancelBtn,
                                 sendBtn,
                                 sepLine,
                                 textView,
                                 ]];
    cancelBtn.sd_layout
    .leftSpaceToView(bottomView, 0)
    .topSpaceToView(bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [cancelBtn setNormalTitle:@"取消"];
    [cancelBtn setBtnFont:PFFontL(16)];
    [cancelBtn setNormalTitleColor:HexColor(#989898)];
    [cancelBtn addBakcgroundColorTheme];
    
    [cancelBtn whenTap:^{
        @strongify(backView)
        @strongify(bottomView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, bottomViewHeight);
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    sendBtn.sd_layout
    .rightSpaceToView(bottomView, 10)
//    .bottomSpaceToView(bottomView, 10)
    .topSpaceToView(bottomView, 0)
    .widthIs(54)
    .heightIs(48)
    ;
    [sendBtn setNormalTitle:@"发布"];
    [sendBtn setBtnFont:PFFontL(16)];
    [sendBtn setNormalTitleColor:HexColor(#989898)];
    [sendBtn addBakcgroundColorTheme];
    
    //监听textfield的输入状态
    textView.textViewDidChangeBlock = ^(UITextView *textView) {
//        GGLog(@"text:%@",textView.text);
        if (textView.text.length>0) {
            [sendBtn setNormalTitleColor:HexColor(#1282EE)];
        }else{
            [sendBtn setNormalTitleColor:HexColor(#989898)];
        }
    };
    
    sepLine.sd_layout
    .topSpaceToView(sendBtn, 0)
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .heightIs(1)
    ;
    
    textView.sd_layout
    .topSpaceToView(sepLine, 10)
    .leftSpaceToView(bottomView, 10)
    .rightSpaceToView(bottomView, 10)
    .bottomSpaceToView(bottomView, 10)
    ;
    
    //发送按钮回调
    @weakify(textView)
    [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(textView)
        if ([NSString isEmpty:textView.text]) {
            return ;
        }
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
