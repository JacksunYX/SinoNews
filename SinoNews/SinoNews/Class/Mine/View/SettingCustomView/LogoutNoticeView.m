//
//  LogoutNoticeView.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "LogoutNoticeView.h"

@implementation LogoutNoticeView

static CGFloat anumationTime = 0.3;

+(void)show:(void(^)(void))handlBlock
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0.0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(60, CGRectGetMidY(backView.frame) - 160/2, ScreenW - 60*2, 160)];
    centerView.layer.cornerRadius = 4;
    centerView.backgroundColor = WhiteColor;
    
    [backView addSubview:centerView];
    
    UITapGestureRecognizer *bottomTap = [UITapGestureRecognizer new];
    
    [[bottomTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
    }];
    [centerView addGestureRecognizer:bottomTap];
    
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.21);
    } completion:^(BOOL finished) {
        
    }];
    
    UITapGestureRecognizer *backTap = [UITapGestureRecognizer new];
    WEAK(weakBackView, backView);
    [[backTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        STRONG(strongBackView, weakBackView)
        [UIView animateWithDuration:anumationTime animations:^{
            strongBackView.alpha = 0;
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
        
    }];
    [backView addGestureRecognizer:backTap];
    
    //添加按钮啥的
    UILabel *title = [UILabel new];
    title.textColor = RGBA(0, 0, 0, 1);
    title.font = PFFontL(24);
    
    UILabel *notice = [UILabel new];
    notice.textColor = RGBA(0, 0, 0, 1);
    notice.font = PFFontL(16);
    
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.titleLabel.font = PFFontL(16);
    [confirmBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.titleLabel.font = PFFontL(16);
    [cancelBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    [centerView sd_addSubviews:@[
                                 title,
                                 notice,
                                 confirmBtn,
                                 cancelBtn,
                                 
                                 ]];
    
    title.sd_layout
    .topSpaceToView(centerView, 24)
    .leftSpaceToView(centerView, 19)
    .rightSpaceToView(centerView, 19)
    .heightIs(24)
    ;
    title.text = @"账号管理";
    
    notice.sd_layout
    .topSpaceToView(title, 30)
    .leftEqualToView(title)
    .rightEqualToView(title)
    .heightIs(18)
    ;
    notice.text = @"您确定退出登录吗？";
    
    cancelBtn.sd_layout
    .rightSpaceToView(centerView, 20)
    .bottomSpaceToView(centerView, 20)
    .widthIs(50)
    .heightIs(20)
    ;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    confirmBtn.sd_layout
    .centerYEqualToView(cancelBtn)
    .rightSpaceToView(cancelBtn, 20)
    .widthIs(50)
    .heightIs(20)
    ;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [[confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {

        STRONG(strongBackView, weakBackView)
        [UIView animateWithDuration:anumationTime animations:^{
            strongBackView.alpha = 0;
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
        if (handlBlock) {
            handlBlock();
        }
    }];
    
    
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        STRONG(strongBackView, weakBackView)
        [UIView animateWithDuration:anumationTime animations:^{
            strongBackView.alpha = 0;
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
    }];

}

@end
