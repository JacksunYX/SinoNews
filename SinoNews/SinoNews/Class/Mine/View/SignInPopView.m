//
//  SignInPopView.m
//  SinoNews
//
//  Created by Michael on 2018/7/3.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SignInPopView.h"

@implementation SignInPopView
static CGFloat anumationTime = 0.3;

+(void)showWithData:(NSDictionary *)data
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIView *centerView = [UIView new];
    centerView.alpha = 0;
    centerView.backgroundColor = WhiteColor;
    
    UIImageView *topImgV = [UIImageView new];
    
    UIButton *closeBtn = [UIButton new];
    
    [backView sd_addSubviews:@[
                               centerView,
                               topImgV,
                               closeBtn,
                               ]];
    centerView.sd_layout
    .leftSpaceToView(backView, 50)
    .rightSpaceToView(backView, 50)
    .centerYEqualToView(backView)
    .heightIs(196)
    ;
    [centerView setSd_cornerRadius:@(18)];
    
    topImgV.sd_layout
    .centerXEqualToView(backView)
    .bottomSpaceToView(centerView, -46)
    .widthIs(180)
    .heightIs(95)
    ;
    topImgV.image = UIImageNamed(@"signIn_popTopImg");
    
    closeBtn.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(centerView, 40)
    .widthIs(42)
    .heightEqualToWidth()
    ;
    [closeBtn setImage:UIImageNamed(@"signIn_popClose") forState:UIControlStateNormal];
    //点击移除手势
    @weakify(backView)
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(backView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        centerView.alpha = 1;
    }];
    
    //其他控件
    UILabel *bottonLabel = [UILabel new];
    bottonLabel.textColor = WhiteColor;
    bottonLabel.backgroundColor = RGBA(80, 159, 235, 1);
    bottonLabel.font = PFFontL(15);
    bottonLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *goldBtn = [UIButton new];
    goldBtn.titleLabel.font = PFFontL(20);
    [goldBtn setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    UILabel *centerLabel = [UILabel new];
    centerLabel.font = PFFontL(16);
    centerLabel.textColor = RGBA(50, 50, 50, 1);
    centerLabel.isAttributedContent = YES;
    
    [centerView sd_addSubviews:@[
                                 bottonLabel,
                                 goldBtn,
                                 centerLabel,
                                 
                                 ]];
    bottonLabel.sd_layout
    .leftEqualToView(centerView)
    .bottomEqualToView(centerView)
    .rightEqualToView(centerView)
    .heightIs(43)
    ;
    bottonLabel.text = @"连续签到可获得额外积分";
    
    goldBtn.sd_layout
    .bottomSpaceToView(bottonLabel, 30)
    .centerXEqualToView(centerView)
    .widthIs(100)
    .heightIs(24)
    ;
    
    [goldBtn setTitle:[NSString stringWithFormat:@"+%d",[data[@"points"] intValue]] forState:UIControlStateNormal];
    [goldBtn setImage:UIImageNamed(@"signIn_popGold") forState:UIControlStateNormal];
    goldBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    centerLabel.sd_layout
    .bottomSpaceToView(goldBtn, 10)
    .centerXEqualToView(centerView)
    .heightIs(18)
    ;
    [centerLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 120];
    NSString *integralStr1 = @"已连续签到 ";
    NSString *integralStr2 = [NSString stringWithFormat:@"%d",[data[@"conSignDays"] intValue]];
    NSMutableAttributedString *integralAtt1 = [NSString leadString:integralStr1 tailString:integralStr2 font:PFFontL(20) color:RGBA(18, 130, 238, 1) lineBreak:NO];
    NSString *integralStr3 = @" 天";
    NSMutableAttributedString *integralAtt2 = [[NSMutableAttributedString alloc]initWithString:integralStr3];
    [integralAtt1 appendAttributedString:integralAtt2];
    centerLabel.attributedText = integralAtt1;
    
}



@end
