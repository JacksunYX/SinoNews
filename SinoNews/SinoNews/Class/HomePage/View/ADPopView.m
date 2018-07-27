//
//  ADPopView.m
//  SinoNews
//
//  Created by Michael on 2018/7/3.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ADPopView.h"

@implementation ADPopView

static CGFloat anumationTime = 0.3;

+(void)showWithData:(ADModel *)model
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
    
    UIButton *closeBtn = [UIButton new];
    
    [backView sd_addSubviews:@[
                               centerView,
                               closeBtn,
                               ]];
    centerView.sd_layout
    .leftSpaceToView(backView, 50)
    .rightSpaceToView(backView, 50)
    .centerYEqualToView(backView)
    .heightIs(355)
    ;
    [centerView updateLayout];
    [centerView setSd_cornerRadius:@(18)];
    
    closeBtn.sd_layout
    .centerXEqualToView(backView)
    .topSpaceToView(centerView, 33)
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
    
    UIButton *toSee = [UIButton new];
    toSee.titleLabel.font = PFFontL(17);
    [toSee setTitleColor:RGBA(18, 130, 238, 1) forState:UIControlStateNormal];
    
    UIImageView *topImgV = [UIImageView new];
//    topImgV.backgroundColor = RedColor;
    
    [centerView sd_addSubviews:@[
                                 toSee,
                                 topImgV,
                                 ]];
    
    toSee.sd_layout
    .leftEqualToView(centerView)
    .rightEqualToView(centerView)
    .bottomEqualToView(centerView)
    .heightIs(50)
    ;
    [toSee updateLayout];
    [toSee setTitle:@"前往围观" forState:UIControlStateNormal];
    [toSee addBorderTo:BorderTypeTop borderColor:RGBA(227, 227, 227, 1)];
    
    topImgV.sd_layout
    .topEqualToView(centerView)
    .leftEqualToView(centerView)
    .rightEqualToView(centerView)
    .bottomSpaceToView(toSee, 0)
    ;
//    topImgV.image = UIImageNamed(@"adPopImg");
    [topImgV sd_setImageWithURL:UrlWithStr(GetSaveString(model.url))];
    
    [[toSee rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
//        [[UIApplication sharedApplication] openURL:UrlWithStr(@"https://www.baidu.com")];
        [UniversalMethod jumpWithADModel:model];
        
        @strongify(backView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
}

@end
