//
//  FontAndNightModeView.m
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "FontAndNightModeView.h"
#import "CLSlider.h"
#import "LQXSwitch.h"

@implementation FontAndNightModeView

static CGFloat anumationTime = 0.3;

+(void)show:(void (^)(BOOL, NSInteger))handlBlock
{
    
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0.21);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //下方视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, 180)];
    bottomView.backgroundColor = WhiteColor;
    [backView addSubview:bottomView];
    
    UITapGestureRecognizer *bottomTap = [UITapGestureRecognizer new];
    
    [[bottomTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//        GGLog(@"点击了下半部分");
    }];
    [bottomView addGestureRecognizer:bottomTap];
    
    [UIView animateWithDuration:anumationTime animations:^{
        bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame) - 180, ScreenW, 180);
    }];
    
    UITapGestureRecognizer *backTap = [UITapGestureRecognizer new];
    WEAK(weakBackView, backView);
    [[backTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        STRONG(strongBackView, weakBackView)
        [UIView animateWithDuration:anumationTime animations:^{
            strongBackView.alpha = 0;
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, 180);
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
        
    }];
    [backView addGestureRecognizer:backTap];
    
    //添加按钮啥的
    UIButton *finishBtn = [UIButton new];
    finishBtn.titleLabel.font = PFFontL(17);
    [finishBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    CLSlider *fontSelect = [CLSlider new];
    fontSelect.sliderStyle = CLSliderStyle_Cross;
    fontSelect.thumbTintColor = [UIColor colorWithRed:18/255.0 green:130/255.0 blue:238/255.0 alpha:1];
    fontSelect.thumbShadowColor = [UIColor clearColor];
    fontSelect.thumbDiameter = 14;
    fontSelect.scaleLineColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    fontSelect.scaleLineWidth = 1.0f;
    fontSelect.scaleLineHeight = 14;
    fontSelect.scaleLineNumber = 4;
    if (UserGet(@"fontSize")) {
        [fontSelect setSelectedIndex:[UserGet(@"fontSize") integerValue]];
    }else{
        [fontSelect setSelectedIndex:2];
        UserSet(@"2",@"fontSize")
    }
    
    
    
    UILabel *leftA = [UILabel new];
    leftA.font = PFFontL(15);
    
    UILabel *rightA = [UILabel new];
    leftA.font = PFFontL(14);
    
    UILabel *fonts = [UILabel new];
    fonts.font = PFFontL(17);
    
    UIView *line = [UIView new];
    line.backgroundColor = RGBA(227, 227, 227, 1);
    
    UILabel *nightMode = [UILabel new];
    nightMode.font = PFFontL(16);
    
    LQXSwitch *switchBtn = [[LQXSwitch alloc] initWithFrame:CGRectMake(ScreenW - 59, 13, 49, 20) onColor:RGBA(18, 130, 238, 1) offColor:RGBA(204, 227, 249, 1) font:[UIFont systemFontOfSize:25] ballSize:13];
    [switchBtn setOn:UserGetBool(@"NightMode") animated:YES];
    
    [bottomView sd_addSubviews:@[
                                 finishBtn,
                                 fontSelect,
                                 leftA,
                                 rightA,
                                 fonts,
                                 line,
                                 nightMode,
                                 switchBtn,
                                 ]];
    
    finishBtn.sd_layout
    .leftEqualToView(bottomView)
    .rightEqualToView(bottomView)
    .bottomEqualToView(bottomView)
    .heightIs(49)
    ;
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    
    fontSelect.sd_layout
    .leftSpaceToView(bottomView, 43)
    .rightSpaceToView(bottomView, 38)
    .bottomSpaceToView(finishBtn, 25)
    .heightIs(14)
    ;
    
    leftA.sd_layout
    .leftSpaceToView(bottomView, 10)
    .centerYEqualToView(fontSelect)
    .heightIs(11)
    ;
    [leftA setSingleLineAutoResizeWithMaxWidth:20];
    leftA.text = @"A";
    
    rightA.sd_layout
    .rightSpaceToView(bottomView, 10)
    .centerYEqualToView(fontSelect)
    .heightIs(11)
    ;
    [rightA setSingleLineAutoResizeWithMaxWidth:20];
    rightA.text = @"A";
    
    fonts.sd_layout
    .bottomSpaceToView(finishBtn, 56)
    .leftSpaceToView(bottomView, 11)
    .heightIs(16)
    ;
    [fonts setSingleLineAutoResizeWithMaxWidth:100];
    fonts.text = @"阅读字号";
    
    line.sd_layout
    .leftSpaceToView(bottomView, 10)
    .rightSpaceToView(bottomView, 10)
    .bottomSpaceToView(fonts, 15)
    .heightIs(1)
    ;
    
    nightMode.sd_layout
    .bottomSpaceToView(line, 15)
    .leftEqualToView(fonts)
    .heightIs(16)
    ;
    [nightMode setSingleLineAutoResizeWithMaxWidth:100];
    nightMode.text = @"夜间模式";
    
    switchBtn.sd_layout
    .rightSpaceToView(bottomView, 10)
    .centerYEqualToView(nightMode)
    .widthIs(49)
    .heightIs(20)
    ;
    
    [[finishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        GGLog(@"完成");
        //全局设置字体和夜间模式
        UserSetBool(switchBtn.on, @"NightMode")
  
        NSString *fontSize = [NSString stringWithFormat:@"%ld",fontSelect.currentIdx];
        UserSet(fontSize, @"fontSize")
        //发送修改了字体的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeFontNotify object:nil];
        
        if (handlBlock) {
            handlBlock(switchBtn.on,fontSelect.currentIdx);
        }
        STRONG(strongBackView, weakBackView)
        [UIView animateWithDuration:anumationTime animations:^{
            strongBackView.alpha = 0;
            bottomView.frame = CGRectMake(0, CGRectGetHeight(backView.frame), ScreenW, 180);
        } completion:^(BOOL finished) {
            [strongBackView removeFromSuperview];
        }];
    }];
    
}


@end
