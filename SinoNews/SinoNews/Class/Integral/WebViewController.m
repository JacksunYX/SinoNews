//
//  WebViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WebViewController

-(WKWebView *)webView
{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0]. appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
        preference.minimumFontSize = [GetCurrentFont contentFont].pointSize;
        
        //创建网页配置对象
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = wkUController;
        // 设置偏好设置对象
        config.preferences = preference;
        //默认高度给1，防止网页是纯图片时无法撑开
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
        
        self.webView.navigationDelegate = self;
        [self.webView addBakcgroundColorTheme];
        self.webView.scrollView.delegate = self;
        
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWebViewLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置网页
-(void)setWebViewLoad
{
    [self.view addSubview:self.webView];
    self.webView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    //加载页面
    NSURL *url = UrlWithStr(self.baseUrl);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:0];
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self showOrHideLoadView:NO page:2];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#cfd3d6'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
}

@end
