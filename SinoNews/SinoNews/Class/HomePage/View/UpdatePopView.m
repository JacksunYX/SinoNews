//
//  UpdatePopView.m
//  SinoNews
//
//  Created by Michael on 2018/8/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UpdatePopView.h"

@interface UpdatePopView ()

@end

@implementation UpdatePopView
static CGFloat anumationTime = 0.3;
static int tag = 15532;

+(void)showWithData:(NSDictionary *)data
{
    NSString *appid = @"1420833734";
    NSString *openUrlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid];
    NSURL *openUrl = UrlWithStr(openUrlStr);
    openUrl = UrlWithStr(GetSaveString(data[@"link"]));
    
    //检查一下是否重复
    for (UIView *subView in kWindow.subviews) {
        if (subView.tag == tag) {
            [subView removeFromSuperview];
            break;
        }
    }
    
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - BOTTOM_MARGIN)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIImageView *centerView = [UIImageView new];
    centerView.alpha = 0;
    centerView.userInteractionEnabled = YES;

    [backView addSubview:centerView];
    
    centerView.sd_layout
    .centerXEqualToView(backView)
    .centerYEqualToView(backView)
    .widthIs(292)
    .heightIs(342)
    ;
    [centerView updateLayout];
    centerView.image = UIImageNamed(@"update_popBackView");
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        centerView.alpha = 1;
    }];
    
    UILabel *title = [UILabel new];
    title.font = PFFontR(22);
    title.textColor = HexColor(#3C3C3C);
    title.isAttributedContent = YES;
    
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn setNormalTitleColor:HexColor(#727A81)];
    [cancelBtn setBtnFont:PFFontL(17)];
    
    UIButton *updateBtn = [UIButton new];
    [updateBtn setNormalTitleColor:HexColor(#FFFFFF)];
    [updateBtn setBtnFont:PFFontL(17)];
    [updateBtn setBackgroundColor:HexColor(#1786F2)];
    
    UITextView *descript = [UITextView new];
    descript.showsVerticalScrollIndicator = NO;
    descript.editable = NO;
    
    [centerView sd_addSubviews:@[
                                 title,
                                 cancelBtn,
                                 updateBtn,
                                 descript,
                                 ]];
    title.sd_layout
    .topSpaceToView(centerView, 134)
    .centerXEqualToView(centerView)
    .heightIs(22)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:272];
    NSString *str1 = @"发现新版本 ";
    NSMutableAttributedString *titleAtt = [NSString leadString:str1 tailString:[NSString stringWithFormat:@"V%@",data[@"versionName"]] font:PFFontR(13) color:HexColor(#889199) lineBreak:NO];

    title.attributedText = titleAtt;
    
    cancelBtn.sd_layout
    .leftEqualToView(centerView)
    .bottomEqualToView(centerView)
    .widthRatioToView(centerView, 0.5)
    .heightIs(50)
    ;
    [cancelBtn setNormalTitle:@"以后再说"];
    
    NSInteger type = [data[@"type"] integerValue];
    if (type == 1) {
        updateBtn.sd_layout
        .rightEqualToView(centerView)
        .bottomEqualToView(centerView)
        .widthRatioToView(centerView, 1)
        .heightIs(50)
        ;
        [updateBtn updateLayout];
        [updateBtn cornerWithRadius:9 direction:CornerDirectionTypeBottom];
    }else{
        updateBtn.sd_layout
        .rightEqualToView(centerView)
        .bottomEqualToView(centerView)
        .widthRatioToView(centerView, 0.5)
        .heightIs(48)
        ;
        [updateBtn updateLayout];
        [updateBtn cornerWithRadius:9 direction:CornerDirectionTypeRight];
    }
    [updateBtn setNormalTitle:@"立即升级"];
    
    descript.sd_layout
    .topSpaceToView(title, 10)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 0)
    .bottomSpaceToView(centerView, 50)
    ;
    descript.attributedText = [NSString analysisHtmlString:data[@"description"]];
    //属性设置必须放在后面，不然无效
    descript.font = PFFontL(13);
    descript.textColor = HexColor(#7B838A);
    
    //点击移除手势
    @weakify(backView)
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(backView)
        if (type == 1) {
            return ;
        }
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //更新按钮
    [[updateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(backView)
        //此处跳转到appstore进行更新
        [[UIApplication sharedApplication] openURL:openUrl];
        if (type == 1) {
            return ;
        }
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
}








@end
