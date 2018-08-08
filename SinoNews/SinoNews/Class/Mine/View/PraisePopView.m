//
//  PraisePopView.m
//  SinoNews
//
//  Created by Michael on 2018/7/3.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PraisePopView.h"

@implementation PraisePopView
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
    
    [backView sd_addSubviews:@[
                               centerView,
                               topImgV,
                               ]];
    centerView.sd_layout
    .leftSpaceToView(backView, 50)
    .rightSpaceToView(backView, 50)
    .centerYEqualToView(backView)
    .heightIs(180)
    ;
    [centerView updateLayout];
    [centerView setSd_cornerRadius:@(18)];
    
    topImgV.sd_layout
    .centerXEqualToView(backView)
    .bottomSpaceToView(centerView, -75)
    .widthIs(180)
    .heightIs(100)
    ;
    topImgV.image = UIImageNamed(@"mine_praisePopTopImg");
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        centerView.alpha = 1;
    }];
    
    UIButton *closeBtn = [UIButton new];
    closeBtn.titleLabel.font = PFFontL(16);
    [closeBtn setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    
    UILabel *centerLabel = [UILabel new];
    centerLabel.font = PFFontL(16);
    centerLabel.textColor = RGBA(50, 50, 50, 1);
    
    [centerView sd_addSubviews:@[
                                 closeBtn,
                                 centerLabel,
                                 ]];
    
    closeBtn.sd_layout
    .leftEqualToView(centerView)
    .bottomEqualToView(centerView)
    .rightEqualToView(centerView)
    .heightIs(50)
    ;
    [closeBtn updateLayout];
    [closeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [closeBtn addBorderTo:BorderTypeTop borderColor:RGBA(227, 227, 227, 1)];
    
    centerLabel.sd_layout
    .bottomSpaceToView(closeBtn, 20)
    .centerXEqualToView(centerView)
    .heightIs(18)
    ;
    [centerLabel setSingleLineAutoResizeWithMaxWidth:ScreenW - 120];
    UserModel *user = [UserModel getLocalUserModel];
    NSString *centerText;
    if (data.allKeys.count>0) {
        centerText = [NSString stringWithFormat:@"“%@”共获%ld赞",data[@"username"],[data[@"praisedCount"] integerValue]];
    }else{
        centerText = [NSString stringWithFormat:@"“%@”共获%ld赞",GetSaveString(user.username),user.praisedCount];
    }
    centerLabel.text = centerText;
    
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
}



@end
