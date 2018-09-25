//
//  SignInRuleWebView.m
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "SignInRuleWebView.h"

@interface SignInRuleWebView ()

@end

@implementation SignInRuleWebView
static CGFloat anumationTime = 0.3;

+(void)showWithWebString:(NSString *)webStr
{
    //背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    backView.backgroundColor = RGBA(0, 0, 0, 0);
    //点击移除手势
    @weakify(backView)
    [backView whenTap:^{
        @strongify(backView);
        [UIView animateWithDuration:anumationTime animations:^{
            backView.alpha = 0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    }];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    //中间视图
    UIImageView *centerView = [UIImageView new];
    centerView.image = UIImageNamed(@"signIn_ruleBackImg");
    [centerView whenTap:^{
        
    }];
    
    [backView sd_addSubviews:@[
                               centerView,
                               ]];
    
    centerView.sd_layout
    .topSpaceToView(backView, 80)
    .bottomSpaceToView(backView, 80)
    .leftSpaceToView(backView, 15)
    .rightSpaceToView(backView, 15)
    ;
    
    
    //出现动画
    [UIView animateWithDuration:anumationTime animations:^{
        backView.backgroundColor = RGBA(0, 0, 0, 0.7);
    }];
    
    //添加网页视图
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0]. appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    // 设置字体大小(最小的字体大小)
    //    preference.minimumFontSize = 12;
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = wkUController;
    //    // 设置偏好设置对象
    config.preferences = preference;
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
    
    [centerView addSubview:webView];
    webView.sd_layout
    .leftEqualToView(centerView)
    .rightEqualToView(centerView)
    .topSpaceToView(centerView, 10)
    .bottomSpaceToView(centerView, 10)
    ;
    //加载网页
    NSString *urlStr;
    if (!kStringIsEmpty(webStr)) {
        urlStr = [NSString stringWithFormat:@"%@%@",DefaultDomainName,AppendingString(VersionNum, webStr)];
    }
    
    GGLog(@"文章h5：%@",urlStr);
    NSString *result = [urlStr getUTF8String];
    NSURL *url = UrlWithStr(result);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [webView loadRequest:request];
    
}







@end
