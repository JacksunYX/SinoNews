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
//    bottomView.backgroundColor = WhiteColor;
    [bottomView addBakcgroundColorTheme];
    
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
    [finishBtn addButtonTextColorTheme];
    
    CLSlider *fontSelect = [CLSlider new];
    [fontSelect addBakcgroundColorTheme];
    fontSelect.sliderStyle = CLSliderStyle_Cross;
    fontSelect.thumbTintColor = HexColor(#1282EE);
    fontSelect.thumbShadowColor = [UIColor clearColor];
    fontSelect.thumbDiameter = 14;
    
    fontSelect.scaleLineWidth = 1.0f;
    fontSelect.scaleLineHeight = 14;
    fontSelect.scaleLineNumber = 3;
    if (UserGet(@"fontSize")) {
        [fontSelect setSelectedIndex:[UserGet(@"fontSize") integerValue]];
    }else{
        [fontSelect setSelectedIndex:1];
        UserSet(@"1",@"fontSize")
    }
    
    UILabel *leftA = [UILabel new];
    leftA.font = PFFontL(15);
    
    UILabel *rightA = [UILabel new];
    rightA.font = PFFontL(15);
    
    UILabel *fonts = [UILabel new];
    fonts.font = PFFontL(17);
    
    UIView *line = [UIView new];
    
    UILabel *nightMode = [UILabel new];
    nightMode.font = PFFontL(16);
    
    [leftA addTitleColorTheme];
    [rightA addTitleColorTheme];
    [fonts addTitleColorTheme];
    [nightMode addTitleColorTheme];
    if (UserGetBool(@"NightMode")) {
        line.backgroundColor = CutLineColorNight;
        fontSelect.scaleLineColor = CutLineColorNight;
    }else{
        line.backgroundColor = CutLineColor;
        fontSelect.scaleLineColor = CutLineColor;
    }
    
    LQXSwitch *switchBtn = [[LQXSwitch alloc] initWithFrame:CGRectMake(ScreenW - 59, 13, 49, 30) onColor:RGBA(18, 130, 238, 1) offColor:RGBA(204, 227, 249, 1) font:[UIFont systemFontOfSize:25] ballSize:14];
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
    .heightIs(24)
    ;
    
    [[finishBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        GGLog(@"完成");
        if (switchBtn.on == UserGetBool(@"NightMode") && [UserGet(@"fontSize") integerValue] == fontSelect.currentIdx) {
            GGLog(@"没有任何变化，不需要回调");
            
        }else{
            //全局设置字体和夜间模式
            if (switchBtn.on!=UserGetBool(@"NightMode")) {
                UserSetBool(switchBtn.on, @"NightMode")
                //发送修改了夜间模式的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NightModeChanged object:nil];
                
                if (switchBtn.on) {
                    [LEETheme startTheme:@"NightTheme"];
                }else{
                    [LEETheme startTheme:@"NormalTheme"];
                }
            }
            if ([UserGet(@"fontSize") integerValue] != fontSelect.currentIdx) {
                NSString *fontSize = [NSString stringWithFormat:@"%ld",fontSelect.currentIdx];
                UserSet(fontSize, @"fontSize")
                //发送修改了字体的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeFontNotify object:nil];
            }
            
            //回调
            if (handlBlock) {
                handlBlock(switchBtn.on,fontSelect.currentIdx);
            }
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
