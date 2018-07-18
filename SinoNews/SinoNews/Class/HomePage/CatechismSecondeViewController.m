//
//  CatechismSecondeViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CatechismSecondeViewController.h"

#import "QACommentInputView.h"
#import "ShareAndFunctionView.h"
#import "FontAndNightModeView.h"

@interface CatechismSecondeViewController ()<WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;


@end

@implementation CatechismSecondeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showOrHideLoadView:YES page:2];
    
    [self setWebViewLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
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
    config.userContentController = wkUController;
    // 设置偏好设置对象
    config.preferences = preference;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    self.webView.navigationDelegate = self;
    
    self.webView.scrollView.delegate = self;
    
    [self.view addSubview:self.webView];
    self.webView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 38)
    ;
    
    //加载页面
    NSString *urlStr = @"https://www.youku.com";
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
    
    self.webView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more_night" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }
    });
}

-(void)setBottomView
{
    if (!self.bottomView) {
        self.bottomView = [UIView new];
        [self.view addSubview:self.bottomView];
        
        self.bottomView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        .heightIs(38)
        ;
        [self.bottomView updateLayout];
        [self.bottomView addBorderTo:BorderTypeTop borderColor:HexColor(#E3E3E3)];
        
        _praiseBtn = [UIButton new];
        
        UIButton *shareBtn = [UIButton new];
        UIButton *answerInput = [UIButton new];
        
        @weakify(self)
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦~");
            }else{
                //                [self requestPraiseWithPraiseType:3 praiseId:self.newsId commentNum:0];
            }
        }];
        
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          
                                          _praiseBtn,
                                          answerInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 16)
        .centerYEqualToView(self.bottomView)
        .widthIs(24)
        .heightIs(20)
        ;
        [shareBtn updateLayout];
        [shareBtn setImage:UIImageNamed(@"news_share") forState:UIControlStateNormal];
        
        
        _praiseBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(23)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn setImage:UIImageNamed(@"news_unpraise") forState:UIControlStateNormal];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        answerInput.sd_layout
        .leftSpaceToView(self.bottomView, 40)
        .centerYEqualToView(self.bottomView)
        .widthIs(100)
        .heightIs(20)
        ;
        [answerInput updateLayout];
        
        [answerInput setNormalImage:UIImageNamed(@"news_comment")];
        [answerInput setNormalTitle:@"回复答主..."];
        [answerInput setBtnFont:PFFontL(15)];
        [answerInput setNormalTitleColor:HexColor(#323232)];
        [answerInput layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        
        [answerInput whenTap:^{
            [QACommentInputView showAndSendHandle:^(NSString *inputText) {
                LRToast([@"输入了:" stringByAppendingString:inputText]);
            }];
        }];
    }
    
    self.praiseBtn.selected = YES;
    
}

//更多
-(void)moreSelect
{
    
    @weakify(self)
    [ShareAndFunctionView showWithCollect:YES returnBlock:^(NSInteger section, NSInteger row) {
        @strongify(self)
        //        GGLog(@"点击了第%lu行第%lu个",section,row);
        if (section == 0 && row!=5) {
            NSUInteger sharePlateform = 0;
            switch (row) {
                case 0:
                    sharePlateform = MGShareToWechatSession;
                    break;
                case 1:
                    sharePlateform = MGShareToWechatTimeline;
                    break;
                case 2:
                    sharePlateform = MGShareToQQ;
                    break;
                case 3:
                    sharePlateform = MGShareToQzone;
                    break;
                case 4:
                    sharePlateform = MGShareToSina;
                    break;
                    
                default:
                    break;
            }
            [self shareToPlatform:sharePlateform];
        }else if (section==1) {
            if (row == 0) {
                [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
                    @strongify(self)
                    [self setWebViewLoad];
                }];
            }else if (row == 1) {
                [self.webView reload];
            }else if (row == 2) {
                
            }
            
        }
    }];
}

//分享方法
-(void)shareToPlatform:(MGShareToPlateform)type
{
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DefaultDomainName, @"");
    if (type == MGShareToSina) {
        //如果分享类型是图文，就一定要给图片或者图片链接，无效或为空都是无法分享的
        shareModel.contentType = MGShareContentTypeText;
        shareModel.content = AppendingString(@"测试标题", urlStr);
        //        shareModel.thumbImage = [UIImage imageNamed:@""];
        //        shareModel.image = @"xxx";
    }else{
        shareModel.contentType = MGShareContentTypeWebPage;
        shareModel.title = @"测试标题";
        shareModel.url = urlStr;
        shareModel.content = @"";
        shareModel.thumbImage = [UIImage imageNamed:@""];
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        GGLog(@"分享成功");
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        GGLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
        
    }];
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self showOrHideLoadView:NO page:2];
    
    [self setBottomView];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
}

#pragma mark ---- 请求发送







@end
