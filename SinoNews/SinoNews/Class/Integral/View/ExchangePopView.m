//
//  ExchangePopView.m
//  SinoNews
//
//  Created by Michael on 2018/8/1.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ExchangePopView.h"

@implementation ExchangePopView
static CGFloat anumationTime = 0.3;

+(void)showWithData:(ExchangeRecordModel *)model
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 0)];
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
    .leftSpaceToView(backView, 30)
    .rightSpaceToView(backView, 30)
    .centerYEqualToView(backView)
    ;
    [centerView setSd_cornerRadius:@(11)];
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.7);
        centerView.alpha = 1;
    }];
    
    //点击移除手势
    @weakify(backView);
    [backView whenTap:^{
        @strongify(backView)
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    NSMutableArray *labelArr = [NSMutableArray new];
    [labelArr addObject:[NSString stringWithFormat:@"订单号：%@",GetSaveString(model.orderNo)]];
    [labelArr addObject:[NSString stringWithFormat:@"状态：%@",GetSaveString(model.status)]];
    [labelArr addObject:[NSString stringWithFormat:@"收件人：%@",GetSaveString(model.consignee)]];
    [labelArr addObject:[NSString stringWithFormat:@"联系方式：%@",GetSaveString(model.mobile)]];
    if (model.productType == 1) {
        [labelArr addObject:[NSString stringWithFormat:@"卡号：%@",GetSaveString(model.coupon)]];
    }else{
        [labelArr addObject:[NSString stringWithFormat:@"收货地址：%@",GetSaveString(model.fullAddress)]];
    }
    
    CGFloat topMargin = 22;
    CGFloat bottomMargin = 36;
    
    CGFloat spaceY = 15; //2个labely y轴的间隙
    CGFloat spaceX = 20; //左右间隙
    
    CGFloat y = 0;
    UIView *lastLabel = centerView;
    for (int i = 0; i < labelArr.count; i ++) {
        UILabel *label = [UILabel new];
        label.font = PFFontL(16);
        label.textColor = HexColor(#6E6E6E);
        [centerView addSubview:label];
        
        if (i == 0) {
            y = topMargin;
        }else{
            y = spaceY;
        }
        label.sd_layout
        .topSpaceToView(lastLabel, y)
        .leftSpaceToView(centerView, spaceX)
        .rightSpaceToView(centerView, spaceX)
        .autoHeightRatio(0)
        ;
        label.text = GetSaveString((NSString *)labelArr[i]);
        [label updateLayout];

        lastLabel = label;
        
        if (i == labelArr.count - 1) {
            [centerView setupAutoHeightWithBottomView:label bottomMargin:bottomMargin];
        }
    }
}

@end
