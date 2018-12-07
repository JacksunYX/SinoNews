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
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in keyWindow.subviews) {
        if (subView.tag == tag) {
            return;
        }
    }
    
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    backView.tag = tag;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIImageView *centerView = [UIImageView new];
    centerView.alpha = 0;
    centerView.userInteractionEnabled = YES;
    centerView.backgroundColor = WhiteColor;
    
    UIImageView *topImg = [UIImageView new];
    
    UIButton *cancelBtn = [UIButton new];
    //    [cancelBtn setNormalTitleColor:HexColor(#727A81)];
    //    [cancelBtn setBtnFont:PFFontL(17)];
    
    [backView sd_addSubviews:@[
                               centerView,
                               topImg,
                               cancelBtn,
                               ]];
    
    centerView.sd_layout
    .centerXEqualToView(backView)
    .centerYEqualToView(backView)
    .widthIs(300)
    .heightIs(320)
    ;
    centerView.sd_cornerRadius = @7;
    [centerView updateLayout];
    
    topImg.sd_layout
    .bottomSpaceToView(centerView, -50)
    .centerXEqualToView(centerView)
    .widthIs(128)
    .heightIs(95)
    ;
    topImg.image = UIImageNamed(@"updateNew_logo");
    
    cancelBtn.sd_layout
    //    .leftEqualToView(centerView)
    //    .bottomEqualToView(centerView)
    //    .widthRatioToView(centerView, 0.5)
    //    .heightIs(50)
    .bottomSpaceToView(centerView, 11)
    .rightEqualToView(centerView)
    .widthIs(24)
    .heightEqualToWidth()
    ;
    //    [cancelBtn setNormalTitle:@"以后再说"];
    [cancelBtn setNormalImage:UIImageNamed(@"updateNew_close")];
    
//    centerView.image = UIImageNamed(@"update_popBackView");
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        centerView.alpha = 1;
    }];
    
    UILabel *title = [UILabel new];
    title.font = PFFontR(18);
    title.textColor = HexColor(#161A24);
    title.isAttributedContent = YES;
    
    UILabel *subTitle = [UILabel new];
    subTitle.font = PFFontL(13);
    subTitle.textColor = HexColor(#508EE0);
    
    UIButton *updateBtn = [UIButton new];
    [updateBtn setNormalTitleColor:HexColor(#FFFFFF)];
    [updateBtn setBtnFont:PFFontL(16)];
    [updateBtn setBackgroundColor:HexColor(#1786F2)];
    
    UITextView *descript = [UITextView new];
    descript.showsVerticalScrollIndicator = NO;
    descript.editable = NO;
    
    [centerView sd_addSubviews:@[
                                 title,
                                 subTitle,
                                 updateBtn,
                                 descript,
                                 ]];
    
    title.sd_layout
//    .topSpaceToView(centerView, 134)
    .topSpaceToView(centerView, 60)
    .centerXEqualToView(centerView)
    .heightIs(20)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:250];
    title.text = [NSString stringWithFormat:@"V%@新版升级",data[@"versionName"]];
    
    subTitle.sd_layout
    .centerXEqualToView(centerView)
    .topSpaceToView(title, 16)
    .heightIs(14)
    ;
    [subTitle setSingleLineAutoResizeWithMaxWidth:250];
    subTitle.text = @"99%的名利场已更新，就等您哟";
    
    /*
    NSString *str1 = @"发现新版本 ";
    NSMutableAttributedString *titleAtt = [NSString leadString:str1 tailString:[NSString stringWithFormat:@"V%@",data[@"versionName"]] font:PFFontR(13) color:HexColor(#889199) lineBreak:NO];

    title.attributedText = titleAtt;
     */
    
    updateBtn.sd_layout
    .centerXEqualToView(centerView)
    .bottomSpaceToView(centerView, 20)
    .widthIs(200)
    .heightIs(44)
    ;
    [updateBtn updateLayout];
    updateBtn.sd_cornerRadius = @22;
    
    NSInteger type = [data[@"type"] integerValue];
    if (type) {
        cancelBtn.hidden = YES;
    }else{
        cancelBtn.hidden = NO;
    }
    /*
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
     */
    [updateBtn setNormalTitle:@"立即更新"];
    
    descript.sd_layout
    .topSpaceToView(subTitle, 10)
    .leftSpaceToView(centerView, 15)
    .rightSpaceToView(centerView, 15)
    .bottomSpaceToView(updateBtn, 10)
    ;
    descript.attributedText = [NSString analysisHtmlString:data[@"description"]];
    //属性设置必须放在后面，不然无效
    descript.font = PFFontL(15);
    descript.textColor = HexColor(#161A24);
    
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
