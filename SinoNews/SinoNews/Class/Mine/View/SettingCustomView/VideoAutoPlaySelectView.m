//
//  VideoAutoPlaySelectView.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "VideoAutoPlaySelectView.h"

@implementation VideoAutoPlaySelectView

static CGFloat anumationTime = 0.3;

+(void)show:(selectBlock)handlBlock
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0.0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(36, CGRectGetMidY(backView.frame) - 190/2, ScreenW - 36*2, 190)];
    centerView.layer.cornerRadius = 7;
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
//            centerView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, 190);
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
        
    }];
    [backView addGestureRecognizer:backTap];
    
    //添加按钮啥的
    UILabel *title = [UILabel new];
    title.textColor = RGBA(53, 53, 53, 1);
    title.font = PFFontR(17);
    
    UIButton *btn1 = [UIButton new];
    btn1.tag = 0;
    btn1.titleLabel.font = PFFontL(16);
    [btn1 setTitleColor:RGBA(53, 53, 53, 1) forState:UIControlStateNormal];
    
    UIButton *btn2 = [UIButton new];
    btn2.tag = 1;
    btn2.titleLabel.font = PFFontL(16);
    [btn2 setTitleColor:RGBA(53, 53, 53, 1) forState:UIControlStateNormal];
    
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.titleLabel.font = PFFontL(15);
    [cancelBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    [centerView sd_addSubviews:@[
                                 title,
                                 btn1,
                                 btn2,
                                 cancelBtn,
                                 
                                 ]];
    
    title.sd_layout
    .topSpaceToView(centerView, 30)
    .leftSpaceToView(centerView, 30)
    .rightSpaceToView(centerView, 30)
    .heightIs(18)
    ;
    title.text = @"视频自动播放";
    
    cancelBtn.sd_layout
    .rightSpaceToView(centerView, 35)
    .bottomSpaceToView(centerView, 20)
    .widthIs(50)
    .heightIs(20)
    ;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    btn1.sd_layout
    .topSpaceToView(title, 20)
    .leftEqualToView(title)
    .rightEqualToView(title)
    .heightIs(20)
    ;
    [btn1 updateLayout];
    [btn1 setTitle:@"仅Wi-Fi网络" forState:UIControlStateNormal];
    [btn1 setImage:UIImageNamed(@"setting_nightModeUnSelected") forState:UIControlStateNormal];
    [btn1 setImage:UIImageNamed(@"setting_nightModeSelected") forState:UIControlStateSelected];
    //button文字的偏移量
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btn1.imageView.frame.origin.x + btn1.imageView.frame.size.width), 0, 0);
    //button图片的偏移量
    btn1.imageEdgeInsets = UIEdgeInsetsMake(0, -(btn1.imageView.frame.origin.x), 0, btn1.imageView.frame.origin.x);
    
    btn2.sd_layout
    .topSpaceToView(btn1, 20)
    .leftEqualToView(title)
    .rightEqualToView(title)
    .heightIs(20)
    ;
    [btn2 updateLayout];
    [btn2 setTitle:@"从不" forState:UIControlStateNormal];
    [btn2 setImage:UIImageNamed(@"setting_nightModeUnSelected") forState:UIControlStateNormal];
    [btn2 setImage:UIImageNamed(@"setting_nightModeSelected") forState:UIControlStateSelected];
    //button文字的偏移量
    btn2.titleEdgeInsets = UIEdgeInsetsMake(0,  -(btn2.imageView.frame.origin.x + btn2.imageView.frame.size.width) - 33, 0, 0);
    //button图片的偏移量
    btn2.imageEdgeInsets = UIEdgeInsetsMake(0, -(btn2.imageView.frame.origin.x), 0, btn2.imageView.frame.origin.x);
    
    WEAK(weakBtn1, btn1)
    WEAK(weakBtn2, btn2)
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG(strongBtn1, weakBtn1)
        STRONG(strongBtn2, weakBtn2)
        if (strongBtn1.isSelected) {
            return ;
        }else{
            strongBtn1.selected = !strongBtn1.selected;
            strongBtn2.selected = !strongBtn2.selected;
            if (handlBlock) {
                handlBlock(0);
            }
        }
    }];
    
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG(strongBtn1, weakBtn1)
        STRONG(strongBtn2, weakBtn2)
        if (strongBtn2.isSelected) {
            return ;
        }else{
            strongBtn1.selected = !strongBtn1.selected;
            strongBtn2.selected = !strongBtn2.selected;
            if (handlBlock) {
                handlBlock(1);
            }
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
    
    if (UserGetBool(@"VideoAutoPlay")) {
        btn1.selected = YES;
        btn2.selected = NO;
    }else{
        btn1.selected = NO;
        btn2.selected = YES;
    }
    
}



@end
