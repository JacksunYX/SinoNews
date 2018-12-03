//
//  CatechismSecondeViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CatechismSecondeViewController.h"
#import "CommentDetailViewController.h"
#import "AnswerDetailModel.h"

#import "QACommentInputView.h"
#import "FontAndNightModeView.h"

#import "CommentCell.h"

@interface CatechismSecondeViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *allUrlArray;
    UIScrollView *bgView;
    
    CGFloat currentScrollY; //记录当前滚动的y轴偏移量
    BOOL isLoadWeb; //是否已经加载过网页了
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentArr;    //回答数组
@property (nonatomic,assign) NSInteger currPage;            //页面(起始为1)

@property (nonatomic,strong) AnswerDetailModel *answerModel;//回答模型

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;

@property (nonatomic,strong) UIView *naviTitle;

@end

@implementation CatechismSecondeViewController
CGFloat static titleViewHeight = 150;
-(NSMutableArray *)commentArr
{
    if (!_commentArr) {
        _commentArr = [NSMutableArray new];
    }
    return _commentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];
    
    [self hiddenTopLine];
    
    [self requestNews_browseAnswer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 49)
    ;
    [_tableView updateLayout];
    _tableView.backgroundColor = ClearColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 0, 0);
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    @weakify(self);
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.webView.loading) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.commentArr.count) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestShowAnswerComment];
    }];
    
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 1;
    [self requestShowAnswerComment];
}

-(void)setTitle
{
    if (!self.titleView) {
        self.titleView = [UIView new];
        [self.titleView addBakcgroundColorTheme];
        [self.view insertSubview:self.titleView belowSubview:self.tableView];
        self.titleView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        //        .heightIs(titleViewHeight)
        
        ;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = PFFontM(22);
        _titleLabel.numberOfLines = 0;
        [_titleLabel addTitleColorTheme];
        
        _avatar = [UIImageView new];
        
        _authorName = [UILabel new];
        _authorName.font = PFFontR(12);
        _authorName.textColor = HexColor(#889199);
        
        _idView = [UIView new];
        _idView.backgroundColor = ClearColor;
        
        _creatTime = [UILabel new];
        _creatTime.font = PFFontR(12);
        _creatTime.textColor = HexColor(#889199);
        
        @weakify(self);
        _attentionBtn = [UIButton new];
        [_attentionBtn setNormalTitleColor:WhiteColor];
        
        [_attentionBtn setNormalTitle:@" 关注"];
        [_attentionBtn setSelectedTitle:@"已关注"];
        
        [_attentionBtn setNormalBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)]];
        
        _attentionBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            
            if (UserGetBool(@"NightMode")) {
                [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#1C1F2C)]];
                [(UIButton *)item setSelectedTitleColor:HexColor(#4E4F53)];
            }else{
                [(UIButton *)item setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#e3e3e3)]];
                [(UIButton *)item setSelectedTitleColor:WhiteColor];
            }
        });
        
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestIsAttention];
        }];
        
        [_attentionBtn setBtnFont:PFFontR(14)];
        
        [self.titleView sd_addSubviews:@[
                                         _titleLabel,
                                         _avatar,
                                         _authorName,
                                         _idView,
                                         _creatTime,
                                         _attentionBtn,
                                         ]];
        _titleLabel.sd_layout
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .topEqualToView(self.titleView)
        //    .heightIs(50)
        .autoHeightRatio(0)
        ;
        _titleLabel.text = GetSaveString(self.answerModel.newsTitle);
        
        CGFloat wid = 24;
        if (kStringIsEmpty(self.answerModel.avatar)) {
            wid = 0;
        }
        _avatar.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel, 7)
        .widthIs(wid)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.answerModel.avatar))];
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        _authorName.text = GetSaveString(self.answerModel.username);
        
        _idView.sd_layout
        .heightIs(20)
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_authorName, 10)
        .widthIs(0)
        ;
        
        [self setIdViewWithIDs];
        
        _creatTime.sd_layout
        .centerYEqualToView(_authorName)
        .leftSpaceToView(_idView, 5)
        .rightSpaceToView(_attentionBtn, 10)
        .heightIs(12)
        ;
        _creatTime.text = GetSaveString(self.answerModel.createTime);
        _creatTime.text = GetSaveString(self.answerModel.createTime);
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(58)
        .heightIs(20)
        ;
        
        [_attentionBtn setSd_cornerRadius:@8];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:10];
    }
    
    _attentionBtn.selected = self.answerModel.hasFollow;
    if (_attentionBtn.selected) {
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    
    //如果是用户本人发布的文章，就不显示关注的按钮
    if (![UserModel showAttention:self.answerModel.userId]) {
        [_attentionBtn removeFromSuperview];
//        [self.topAttBtn removeFromSuperview];
    }
    
//    _titleLabel.font = [GetCurrentFont titleFont];
    
    //获取上部分的高度
    [self.titleView updateLayout];
    //向下取整
    titleViewHeight = floorf(self.titleView.height);
//    GGLog(@"titleViewHeight:%f",titleViewHeight);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
    
//    _tableView.contentOffset = CGPointMake(0, -titleViewHeight + 1);
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.answerModel.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.answerModel.identifications.count; i ++) {
            NSDictionary *model = self.answerModel.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [_idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            
            approveView.sd_layout
            .centerYEqualToView(_idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
//            [approveView setSd_cornerRadius:@(wid/2)];
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            approveView.contentMode = 1;
            
            lastView = approveView;
            if (i == self.answerModel.identifications.count - 1) {
                [_idView setupAutoWidthWithRightView:approveView rightMargin:0];
            }
        }
    }else{
        
    }
}


-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _naviTitle.alpha = 0;
        
        [_naviTitle addBakcgroundColorTheme];
        
        CGFloat wid = 0;
        if (self.answerModel.avatar.length>0) {
            wid = 30;
        }
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.answerModel.avatar))];
        
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        username.text = GetSaveString(self.answerModel.username);
        [username sizeToFit];
        CGFloat labelW = CGRectGetWidth(username.frame);
        if (labelW>150*ScaleW) {
            labelW = 150*ScaleW;
        }
        username.frame = CGRectMake(CGRectGetMaxX(avatar.frame) + 5, 0, labelW, 30);
        [_naviTitle addSubview:username];
        
        _naviTitle.frame = CGRectMake(0, 0, 5 * 2 + wid + username.width, 30);
        
        @weakify(self);
        [self.naviTitle whenTap:^{
            @strongify(self);
            [UserModel toUserInforVcOrMine:self.answerModel.userId];
        }];
        
        self.navigationItem.titleView = _naviTitle;
        
    }
}

-(void)setNavigationBtns
{
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more_night" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
            
            self.navigationItem.rightBarButtonItems = @[more];
        }
    });
}

//设置网页
-(void)setWebViewLoad
{
    NSString *jScript = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
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
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
    self.webView.navigationDelegate = self;
    [self.webView addBakcgroundColorTheme];
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    
    //KVO监听web的高度变化
    @weakify(self)
    [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //        GGLog(@"x:%@",x);
        CGFloat newHeight = self.webView.scrollView.contentSize.height;
        if (newHeight != self.topWebHeight) {
            self.topWebHeight = newHeight;
            self.webView.frame = CGRectMake(0, 0, ScreenW, self.topWebHeight);
            //            GGLog(@"topWebHeight:%lf",topWebHeight);
//            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
//            [self.tableView endUpdates];
        }
    }];
    
    //加载页面
    NSString *urlStr = AppendingString(DomainString, self.answerModel.contentUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSString *result = [urlStr getUTF8String];
    NSURL *url = UrlWithStr(result);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
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
        .heightIs(49)
        ;
        [self.bottomView updateLayout];
        self.bottomView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            
            if (UserGetBool(@"NightMode")) {
                [(UIView *)item addBorderTo:BorderTypeTop borderColor:CutLineColorNight];
            }else{
                [(UIView *)item addBorderTo:BorderTypeTop borderColor:CutLineColor];
            }
        });
        
        _praiseBtn = [UIButton new];
        
        UIButton *shareBtn = [UIButton new];
        UIButton *answerInput = [UIButton new];
        
        @weakify(self)
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:4 praiseId:self.answer_id commentNum:0];
            }
        }];
        
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self moreSelect];
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          
                                          _praiseBtn,
                                          answerInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 16)
        .centerYEqualToView(self.bottomView)
        .widthIs(21)
        .heightIs(21)
        ;
        [shareBtn updateLayout];
        [shareBtn addButtonNormalImage:@"news_share"];
        
        _praiseBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn addButtonNormalImage:@"news_unPraise"];
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
        [answerInput setNormalTitleColor:RGBA(148, 152, 153, 1)];
        [answerInput layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        
        [answerInput whenTap:^{
            @strongify(self)
            [QACommentInputView showAndSendHandle:^(NSString *inputText) {
                if (![NSString isEmpty:inputText]) {
                    [self requestAnswerCommentWithComment:inputText];
                }else{
                    LRToast(@"请输入有效的内容");
                }
            }];
        }];
    }
    
    self.praiseBtn.selected = self.answerModel.hasPraise;
    
}

//更多
-(void)moreSelect
{
    @weakify(self)
    /*
    [ShareAndFunctionView showWithCollect:YES returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
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
    */
    [ShareAndFunctionView showWithNoCollectreturnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        if (section==1) {
            switch (row) {
                case 0:
                {
                    [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
                        @strongify(self)
                        [self setWebViewLoad];
                    }];
                }
                    break;
                case 1:
                {
#ifdef OpenNightChange
                    [self.webView reload];
#else
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = AppendingString(DomainString, self.answerModel.contentUrl);
                    LRToast(@"链接已复制");
#endif
                }
                    break;
                case 2:
                {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = AppendingString(DomainString, self.answerModel.contentUrl);
                    LRToast(@"链接已复制");
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}


//分享方法
-(void)shareToPlatform:(MGShareToPlateform)type
{
#ifdef JoinThirdShare
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DomainString, self.answerModel.contentUrl);
    if (type == MGShareToSina) {
        //如果分享类型是图文，就一定要给图片或者图片链接，无效或为空都是无法分享的
        shareModel.contentType = MGShareContentTypeText;
        shareModel.content = AppendingString(GetSaveString(self.answerModel.newsTitle), urlStr);
        //        shareModel.thumbImage = [UIImage imageNamed:@""];
        //        shareModel.image = @"xxx";
    }else{
        shareModel.contentType = MGShareContentTypeWebPage;
        shareModel.title = GetSaveString(self.answerModel.newsTitle);
        shareModel.url = urlStr;
        shareModel.content = self.answerModel.username;
        shareModel.thumbImage = UIImageNamed(@"AppIcon");
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        GGLog(@"分享成功");
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        GGLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
        
    }];
#endif
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self setBottomView];
    
//    [self setNavigationBtns];
    
    [self refreshComments];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    CGFloat y = -titleViewHeight;
    if (isLoadWeb) {
        y = currentScrollY;
    }
    //滚到标题偏移坐标
    _tableView.contentOffset = CGPointMake(0, y+0.5);
    isLoadWeb = YES;
    
    [self showOrHideLoadView:NO page:2];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
    
    //js方法遍历图片添加点击事件 返回图片个数
    /*这块我着重说几句
     逻辑:
     1.遍历获取全部的图片;
     2.生成一个Srting为所有图片的拼接,拼接时拿到所处数组下标;
     3.为图片添加点击事件,并添加数组所处下标
     注意点:
     1.如果仅仅拿到url而无下标的话,网页中如果有多张相同地址的图片 则会发生位置错乱
     2.声明时不要用 var yong let  不然方法添加的i 永远是length的值
     */
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(let i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src +'LQXindex'+ i +'L+Q+X';\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src + 'LQXindex' + i;\
    };\
    };\
    return imgScr;\
    };";
    //注入js方法
    [webView evaluateJavaScript:jsGetImages completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    
    @weakify(self);
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        @strongify(self);
        NSString *urlResurlt = result;
        self->allUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"L+Q+X"]];
        if (self->allUrlArray.count >= 2) {
            [self->allUrlArray removeLastObject];// 此时数组为每一个图片的url
        }
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        [self anotherImageBrowser:imageUrl];
        
    }else if ([requestString hasPrefix:@"http"]&&!self.webView.loading) {
        // 拦截点击链接
        [[UIApplication sharedApplication] openURL:UrlWithStr(requestString)];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

#pragma mark 显示大图片

//第二种查看图片的方式
-(void)anotherImageBrowser:(NSString *)imageUrl
{
    //获取下标
    NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
    int i = [imageIndex.lastObject intValue];
    
    NSMutableArray *images = [NSMutableArray new];
    for (int j = 0; j < allUrlArray.count; j ++) {
        NSArray *imageArr = [NSMutableArray arrayWithArray:[allUrlArray[j] componentsSeparatedByString:@"LQXindex"]];
        [images addObject:imageArr.firstObject];
    }
    //创建图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = i;
    browser.imageArray = images;
    [browser show];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CommentCellID];
    CompanyCommentModel *model = self.commentArr[indexPath.row];
    cell.model = model;
    @weakify(self)
    //点赞
    cell.praiseBlock = ^(NSInteger row) {
        @strongify(self)
        if (model.isPraise) {
            LRToast(@"已经点过赞啦");
        }else{
            [self requestPraiseWithPraiseType:7 praiseId:[model.commentId integerValue] commentNum:indexPath.row];
        }
    };
    //头像
    cell.avatarBlock = ^(NSInteger row) {
        [UserModel toUserInforVcOrMine:[model.userId integerValue]];
    };
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 42)];
        UILabel *title = [UILabel new];
        title.font = PFFontR(13);
        title.lee_theme.LeeConfigTextColor(@"titleColor");
        [headView addSubview:title];
        //布局
        title.sd_layout
        .centerYEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        if (self.answerModel) {
            NSInteger count = MAX(self.answerModel.commentCount, self.commentArr.count);
            if (count) {
                title.text = [NSString stringWithFormat:@"全部评论(%ld)",count];
            }else{
                title.text = @"全部评论";
            }
        }
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentDetailViewController *cdVC = [CommentDetailViewController new];
    cdVC.model = self.commentArr[indexPath.row];
    cdVC.pushType = 2;
    cdVC.answerId = self.answer_id;
    [self.navigationController pushViewController:cdVC animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    GGLog(@"touchesBegan点击了");
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    
    if (self.attentionBtn.enabled) {
        //如果大于，说明tableView便宜量已经看不到头像等信息了
        if (self.tableView.contentOffset.y + titleViewHeight >=10 + 24) {
            GGLog(@"不能点击");
        }else{
            
            if (x >= ScreenW - (58+10)&&x<= ScreenW - 10 && y >= titleViewHeight - 10 - 24/2 - 20/2 && y <= titleViewHeight - 10 - 24/2 + 20/2) {
                GGLog(@"点击了关注");
                [self requestIsAttention];
            }else if (x >= 10&&x<= (100+10) && y >= titleViewHeight - 10 - 24 && y <= titleViewHeight - 10) {
                GGLog(@"点击用户部分");
                [UserModel toUserInforVcOrMine:self.answerModel.userId];
            }
        }
    }
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
//    GGLog(@"contentOffset.y:%f",offsetY);
    currentScrollY = offsetY;
    if (offsetY >= - titleViewHeight&&offsetY < 0) {
        //计算透明度比例
        CGFloat alpha = MAX(0, (titleViewHeight - fabs(offsetY)) / titleViewHeight);
        NSString *process = [NSString stringWithFormat:@"%.1lf",alpha];
//        GGLog(@"min:%@",process);
        self.titleView.alpha = 1 - [process floatValue];
        self.attentionBtn.enabled = 1 - [process floatValue];
        self.naviTitle.alpha = [process floatValue];
        
        [self hiddenTopLine];
        
    }else{
        if (offsetY>0) {
            [self showTopLine];
            self.naviTitle.alpha = 1;
            self.titleView.alpha = 0;
            self.attentionBtn.enabled = NO;
        }else{
            [self hiddenTopLine];
            self.naviTitle.alpha = 0;
            self.titleView.alpha = 1;
            self.attentionBtn.enabled = YES;
        }
    }
    
}

#pragma mark ---- 请求发送
//查看回答
-(void)requestNews_browseAnswer
{
    [HttpRequest postWithURLString:News_browseAnswer parameters:@{@"answerId":@(self.answer_id)} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.answerModel = [AnswerDetailModel mj_objectWithKeyValues:response[@"data"]];
        self.commentArr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:self.answerModel.comments];
        self.currPage = 1;
        
        [self setWebViewLoad];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } RefreshAction:nil];
}

//关注/取关
-(void)requestIsAttention
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.answerModel.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
//        UserModel *user = [UserModel getLocalUserModel];
        NSInteger status = [res[@"data"][@"status"] integerValue];
        if (status == 1) {
//            user.followCount ++;
            LRToast(@"关注成功");
        }else{
//            user.followCount --;
            LRToast(@"已取消关注");
        }
        self.answerModel.hasFollow = status;
        //覆盖之前保存的信息
//        [UserModel coverUserData:user];
        [self setTitle];
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
    
}

//点赞文章/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if (praiseType == 7) {
            CompanyCommentModel *model = self.commentArr[row];
            
            NSInteger status = [res[@"data"][@"success"] integerValue];
            if (status) {
                LRToast(@"点赞成功");
                model.isPraise = YES;
                model.likeNum ++;
            }
            [self.tableView reloadData];
        }
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
    
}

//评论列表
-(void)requestShowAnswerComment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"answerId"] = @(self.answer_id);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest postWithURLString:ShowAnswerComment parameters:parameters isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSArray *data = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        
        self.commentArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.commentArr];

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    } RefreshAction:nil];
}

//添加回答评论
-(void)requestAnswerCommentWithComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"comment"] = comment;
    parameters[@"answerId"] = @(self.answer_id);
    parameters[@"parentId"] = @(0);
    [HttpRequest postWithTokenURLString:AnswerComment parameters:parameters isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id res) {
        LRToast(@"评论已发送");
        CompanyCommentModel *addComment = [CompanyCommentModel mj_objectWithKeyValues:res[@"data"]];
        [self.commentArr insertObject:addComment atIndex:0];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestNews_browseAnswer];
    }];
}


@end
