//
//  VoteViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "VoteViewController.h"

@interface VoteViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投票";
    
    [self showOrHideLoadView:YES page:2];
    
    [self requestNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置网页
-(void)setWebViewLoad
{
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
//    config.userContentController = wkUController;
    // 设置偏好设置对象
    config.preferences = preference;
    //默认高度给1，防止网页是纯图片时无法撑开
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT - BOTTOM_MARGIN) configuration:config];
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    [self.webView addBakcgroundColorTheme];
    self.webView.scrollView.delegate = self;
//    self.webView.allowsBackForwardNavigationGestures = NO;
    
    //加载页面
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.voteUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
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
    
    //防止缩放
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
}

#pragma mark ----- 发送请求
//获取文章详情
-(void)requestNewData
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self setWebViewLoad];
        
    } failure:^(NSError *error) {
        
    }];
}


@end
