//
//  SharePopCopyView.m
//  SinoNews
//
//  Created by Michael on 2018/9/21.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SharePopCopyView.h"
static CGFloat anumationTime = 0.3;
@implementation SharePopCopyView

+(void)showWithData:(NSDictionary *)data
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIImageView *centerView = [UIImageView new];
    centerView.alpha = 0;
    centerView.userInteractionEnabled = YES;
    
    UIButton *copyBtn = [UIButton new];
    
    UILabel *shareLaebl = [UILabel new];
    shareLaebl.font = PFFontR(12);
    shareLaebl.textColor = HexColor(#2790F6);
    shareLaebl.numberOfLines = 1;
    
    UITextView *noticeView = [UITextView new];
    noticeView.textColor = HexColor(#36373A);
    noticeView.font = PFFontL(13);
    
    [backView addSubview:centerView];
    centerView.sd_layout
    .widthIs(352)
    .heightIs(302)
    .centerYEqualToView(backView)
    .centerXEqualToView(backView)
    ;
    centerView.image = UIImageNamed(@"share_popToCopyBackImg");
    
    [centerView sd_addSubviews:@[
                                 copyBtn,
                                 shareLaebl,
                                 noticeView,
                                 ]];
    
    copyBtn.sd_layout
    .bottomSpaceToView(centerView, 10)
    .centerXEqualToView(centerView)
    .widthIs(156)
    .heightIs(36)
    ;
    [copyBtn setSd_cornerRadius:@18];
    copyBtn.backgroundColor = HexColor(#2790F6);
    [copyBtn setNormalTitle:@"复制链接"];
    [copyBtn setNormalTitleColor:WhiteColor];
    [copyBtn setBtnFont:PFFontR(15)];
    
    shareLaebl.sd_layout
    .leftSpaceToView(centerView, 15+54)
    .rightSpaceToView(centerView, 15+54)
    .bottomSpaceToView(copyBtn, 20)
    .heightIs(13)
    ;
    
    
    NSString *shareUrl = AppendingString(DomainString, @"/share?");
    /*
    NSString *userId = [NSString stringWithFormat:@"%@",data[@"userId"]];
//    NSString *source = [NSString stringWithFormat:@"%@",data[@"source"]];
    
    NSString *field = [NSString stringWithFormat:@"u=%@",[self thirdDesWithText:userId]];
    */
    shareUrl = GetSaveString(data[@"url"]);
     
    shareLaebl.text = shareUrl;
    
    noticeView.sd_layout
    .leftSpaceToView(centerView, 15+54+12)
    .rightSpaceToView(centerView, 15+54+12)
    .bottomSpaceToView(shareLaebl, 15)
    .topSpaceToView(centerView, 54 + 40)
    ;
//    noticeView.text = @"注册启世录就送10元话费！领取1000积分兑换话费卡、购物卡、iphone XS手机等千种奖品！注册时输入推广码即可领取1000积分，现在就下载App吧！";
    noticeView.text = GetSaveString(data[@"text"]);
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.82);
        centerView.alpha = 1;
    }];
    
    @weakify(backView);
    //点击复制
    [[copyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(backView);
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = AppendingString(noticeView.text,shareLaebl.text);
        GGLog(@"加密链接：%@",shareUrl);
        LRToast(@"链接已复制");
        
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    //点击移除手势
    [backView whenTap:^{
        @strongify(backView);
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];

}

//加密方式
+(NSString *)thirdDesWithText:(NSString *)plainText
{
    NSString *key = @"qazxrfvb";
    NSString *iv = @"0000000000000000";
    
    CryptLib *cryptoLib = [[CryptLib alloc] init];
    NSString *encryptedString = [cryptoLib encryptPlainText:plainText key:key iv:iv];
    GGLog(@"encryptedString %@", encryptedString);
    return encryptedString;
}

@end
