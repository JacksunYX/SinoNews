//
//  NewsDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//


#import "NewsDetailViewController.h"
#import "CommentDetailViewController.h"
#import "HomePageFirstKindCell.h"
#import "NormalNewsModel.h"
#import "CommentCell.h"
#import "HomePageFourthCell.h"

#import "HomePageModel.h"
#import "FontAndNightModeView.h"
#import "ShareAndFunctionView.h"


//未付费标记
#define NoPayedNews (self.newsModel.isToll&&self.newsModel.hasPaid==0)

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>


@property (nonatomic,strong) UITextField *commentInput;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) NSInteger currPage;            //页面(起始为1)
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorAndTime;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,strong) UIView *bottomView2;

@property (nonatomic,assign) NSInteger parentId;

@property (nonatomic,strong) ZYKeyboardUtil *keyboardUtil;

@end

@implementation NewsDetailViewController

CGFloat static titleViewHeight = 91;
-(ZYKeyboardUtil *)keyboardUtil
{
    if (!_keyboardUtil) {
        _keyboardUtil = [[ZYKeyboardUtil alloc]init];
    }
    return _keyboardUtil;
}

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];
    
    [self requestNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBtns
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more_night" hightimage:nil andTitle:@""];
            UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts_night" hightimage:nil andTitle:@""];
            self.navigationItem.rightBarButtonItems = @[more,fonts];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
            UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts" hightimage:nil andTitle:@""];
            self.navigationItem.rightBarButtonItems = @[more,fonts];
        }
    });
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
        _titleLabel.font = [GetCurrentFont titleFont];
        _titleLabel.numberOfLines = 0;
        [_titleLabel addTitleColorTheme];
        
        _avatar = [UIImageView new];
        
        _authorAndTime = [UILabel new];
        _authorAndTime.font = PFFontR(11);
        _authorAndTime.textColor = RGBA(152, 152, 152, 1);
        
        @weakify(self);
        _attentionBtn = [UIButton new];
        [_attentionBtn setNormalTitleColor:WhiteColor];
        [_attentionBtn setSelectedTitleColor:WhiteColor];
        [_attentionBtn setNormalTitle:@" 关注"];
        [_attentionBtn setSelectedTitle:@"已关注"];
        
        [_attentionBtn setNormalBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)]];
        [_attentionBtn setSelectedBackgroundImage:[UIImage imageWithColor:HexColor(#e3e3e3)]];
        
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestIsAttention];
        }];
        
        [_attentionBtn setBtnFont:PFFontR(14)];
        
        [self.titleView sd_addSubviews:@[
                                         _titleLabel,
                                         _avatar,
                                         _authorAndTime,
                                         _attentionBtn,
                                         ]];
        _titleLabel.sd_layout
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .topEqualToView(self.titleView)
        //    .heightIs(50)
        .autoHeightRatio(0)
        ;
        _titleLabel.text = GetSaveString(self.newsModel.newsTitle);
        
        CGFloat wid = 24;
        if (kStringIsEmpty(self.newsModel.avatar)) {
            wid = 0;
        }
        _avatar.sd_layout
        .leftEqualToView(_titleLabel)
        .topSpaceToView(_titleLabel, 7)
        .widthIs(wid)
        .heightIs(24)
        ;
        [_avatar setSd_cornerRadius:@12];
        [_avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.newsModel.avatar))];
        
        _authorAndTime.sd_layout
        .leftSpaceToView(_avatar, 3)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorAndTime setSingleLineAutoResizeWithMaxWidth:200];
        _authorAndTime.text = [NSString stringWithFormat:@"%@    %@",GetSaveString(self.newsModel.author),GetSaveString(self.newsModel.createTime)];
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(58)
        .heightIs(20)
        ;
        
        [_attentionBtn setSd_cornerRadius:@8];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:10];
    }
    
    _attentionBtn.selected = self.newsModel.isAttention;
    if (_attentionBtn.selected) {
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    _titleLabel.font = [GetCurrentFont titleFont];

    //获取上部分的高度
    [self.titleView updateLayout];
    titleViewHeight = self.titleView.height;
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 0, 0);
//    GGLog(@"titleView自适应高度为：%lf",self.titleView.height);
    
    [_tableView setContentOffset:CGPointMake(0, -titleViewHeight) animated:YES];
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
        [self.bottomView addBorderTo:BorderTypeTop borderColor:HexColor(#F2F2F2)];
        
        self.commentInput = [UITextField new];
        self.commentInput.delegate = self;
        self.commentInput.returnKeyType = UIReturnKeySend;
        @weakify(self)
//        [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
//            @strongify(self)
//            GGLog(@"完成编辑");
//            UITextField *field = x.first;
//            GGLog(@"-----%@",field.text);
//            [field resignFirstResponder];
//            if ([NSString isEmpty:field.text]) {
//                LRToast(@"评论不能为空哦~");
//            }else{
//                [self requestCommentWithComment:field.text];
//                field.text = @"";
//            }
//        }];
        [self.commentInput whenTap:^{
            @strongify(self)
            [QACommentInputView showAndSendHandle:^(NSString *inputText) {
                if (![NSString isEmpty:inputText]) {
                    [self requestCommentWithComment:inputText];
                }else{
                    LRToast(@"请输入有效的内容");
                }
            }];
        }];
        
        //        [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        //            GGLog(@"结束编辑");
        //            @strongify(self)
        //
        //        }];
        
        _praiseBtn = [UIButton new];
        _collectBtn = [UIButton new];
        UIButton *shareBtn = [UIButton new];
        
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦~");
            }else{
                [self requestPraiseWithPraiseType:3 praiseId:self.newsId commentNum:0];
            }
        }];
        
        [[_collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestCollectNews];
        }];
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self moreSelect];
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          _collectBtn,
                                          _praiseBtn,
                                          self.commentInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 16)
        .centerYEqualToView(self.bottomView)
        .widthIs(24)
        .heightIs(20)
        ;
        [shareBtn setImage:UIImageNamed(@"news_share") forState:UIControlStateNormal];
        
        _collectBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(25)
        .heightIs(24)
        ;
        [_collectBtn setImage:UIImageNamed(@"news_unCollect") forState:UIControlStateNormal];
        [_collectBtn setImage:UIImageNamed(@"news_collected") forState:UIControlStateSelected];
        
        _praiseBtn.sd_layout
        .rightSpaceToView(_collectBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(23)
        .heightIs(21)
        ;
        [_praiseBtn setImage:UIImageNamed(@"news_unpraise") forState:UIControlStateNormal];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        self.commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 37)
        .rightSpaceToView(_praiseBtn, 30)
        .centerYEqualToView(self.bottomView)
        .heightIs(34)
        ;
        self.commentInput.backgroundColor = RGBA(238, 238, 238, 1);
        [self.commentInput setSd_cornerRadius:@17];
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:@"写评论..."];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontR(14),
                              NSForegroundColorAttributeName : RGBA(53, 53, 53, 1),
                              };
        [placeholder addAttributes:dic range:NSMakeRange(0, placeholder.length)];
        self.commentInput.attributedPlaceholder = placeholder;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 33)];
        UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 21)];
        [leftView addSubview:leftImg];
        leftImg.center = leftView.center;
        leftImg.image = UIImageNamed(@"news_comment");
        self.commentInput.leftViewMode = UITextFieldViewModeAlways;
        self.commentInput.leftView = leftView;
        
        [self.keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
            @strongify(self);
            [keyboardUtil adaptiveViewHandleWithAdaptiveView:self.bottomView, nil];
        }];
    }
    
    self.collectBtn.selected = self.newsModel.isCollection;
    self.praiseBtn.selected = self.newsModel.hasPraised;
    self.bottomView.hidden = NO;
}

-(void)setBottomView2
{
    if (!self.bottomView2) {
        self.bottomView2 = [UIView new];
        self.bottomView2.backgroundColor = WhiteColor;
        [self.view addSubview:self.bottomView2];
        self.bottomView2.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        .heightIs(49)
        ;
        [self.bottomView2 updateLayout];
        
        UIButton *payBtn = [UIButton new];
        payBtn.backgroundColor = RGBA(18, 130, 238, 1);
        payBtn.titleLabel.font = PFFontL(15);
        [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [payBtn setTitle:@"购买" forState:UIControlStateNormal];
        @weakify(self)
        [[payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self requestPayForNews];
        }];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.font = PFFontR(16);
        priceLabel.textColor = RGBA(18, 130, 238, 1);
        priceLabel.text = [NSString stringWithFormat:@"  %ld积分",self.newsModel.points];
        
        [self.bottomView2 sd_addSubviews:@[
                                          payBtn,
                                          priceLabel,
                                          ]];
        payBtn.sd_layout
        .topEqualToView(self.bottomView2)
        .rightEqualToView(self.bottomView2)
        .bottomEqualToView(self.bottomView2)
        .widthIs(95)
        ;
        [payBtn updateLayout];
        
        priceLabel.sd_layout
        .topEqualToView(self.bottomView2)
        .leftEqualToView(self.bottomView2)
        .rightSpaceToView(payBtn, 0)
        .bottomEqualToView(self.bottomView2)
        ;
        [priceLabel updateLayout];
        [priceLabel addBorderTo:BorderTypeTop borderColor:RGBA(227, 227, 227, 1)];
    }
    self.bottomView2.hidden = NO;
}

//下方视图具体显示哪一个
-(void)showBottomView
{
    //收费文章，但是未付费,未付费时不显示评论
    if (NoPayedNews) {
        [self setBottomView2];
        self.bottomView.hidden = YES;
        _tableView.mj_footer = nil;
    }else{
        [self setBottomView];
        self.bottomView2.hidden = YES;
        
        @weakify(self);
        _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if (self.webView.loading) {
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (!self.commentsArr.count) {
                self.currPage = 1;
            }else{
                self.currPage++;
            }
            [self requestComments];
        }];
        [self refreshComments];
    }
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
//    _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    _tableView.enableDirection = YES;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 0;
    [self.tableView.mj_footer beginRefreshing];
}

//字体
-(void)fontsSelect
{
    @weakify(self)
    [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
        @strongify(self)
        [self setWebViewLoad];
    }];
}

//更多
-(void)moreSelect
{
    if (!self.newsModel) {
        return;
    }
    @weakify(self)
    [ShareAndFunctionView showWithCollect:YES returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
            [self shareToPlatform:sharePlateform];
        }else if (section==1) {
            if (row == 0) {
                [self fontsSelect];
            }else if (row == 1) {
                [self.webView reload];
            }else if (row == 2) {
                [self requestCollectNews];
            }else if (row == 3) {
                LRToast(@"链接已复制");
            }
            
        }
    }];
    
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
    //默认高度给1，防止网页是纯图片时无法撑开
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) configuration:config];
    self.webView.navigationDelegate = self;
    [self.webView addBakcgroundColorTheme];
    self.webView.scrollView.delegate = self;
    self.webView.userInteractionEnabled = NO;
    
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
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView endUpdates];
        }
    }];
    
    
    //加载页面
    
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
    
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
}

//让输入框无法进入编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
    
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [self showOrHideLoadView:NO page:2];
    
    [self showBottomView];
    
    [self setNavigationBtns];
    
    GCDAfterTime(0.5, ^{
        [self setTitle];
    });
    
//    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
//        CGFloat height = [data floatValue];
//        GGLog(@"height:%lf",height);
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        //设置通知或者代理来传高度
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
//    }];
    
    //修改字体大小 300%
//    NSString *fontStr = @"100%";
//    if ([GetCurrentFont contentFont].pointSize == 12) {
//        fontStr = @"80%";
//    }else if ([GetCurrentFont contentFont].pointSize == 13){
//        fontStr = @"90%";
//    }else if ([GetCurrentFont contentFont].pointSize == 14){
//        fontStr = @"100%";
//    }else if ([GetCurrentFont contentFont].pointSize == 15){
//        fontStr = @"120%";
//    }else if ([GetCurrentFont contentFont].pointSize == 16){
//        fontStr = @"150%";
//    }
//
//    [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'",fontStr] completionHandler:nil];
    
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

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.newsModel.relatedNews.count;
    }else if (section == 1){
        return self.commentsArr.count;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
//        HomePageFirstKindCell *cell0 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
//        cell0.model = self.newsModel.relatedNews[indexPath.row];
//        cell0.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
//        cell = (UITableViewCell *)cell0;
        id model = self.newsModel.relatedNews[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = (HomePageModel *)model;
            //暂时只分2种
            if (model1.itemType == 100) {//无图
                HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }else{//1图
                HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
        }
        
    }else if (indexPath.section == 1){
        CommentCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CommentCellID];
        cell2.tag = indexPath.row;
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        cell2.model = model;
        @weakify(self)
        //点赞
        cell2.praiseBlock = ^(NSInteger row) {
            GGLog(@"点赞的commendId:%@",model.commentId);
            @strongify(self)
            if (model.isPraise) {
                LRToast(@"已经点过赞啦～");
            }else{
                [self requestPraiseWithPraiseType:2 praiseId:[model.commentId integerValue] commentNum:row];
            }
        };
        //点击头像
        cell2.avatarBlock = ^(NSInteger row) {
            @strongify(self)
            UserInfoViewController *uiVC = [UserInfoViewController new];
            uiVC.userId = [model.userId integerValue];
            [self.navigationController pushViewController:uiVC animated:YES];
        };
        //回复TA
        //        cell2.replayBlock = ^(NSInteger row) {
        //            @strongify(self)
        //            self.parentId = [model.commentId integerValue];
        //            [self.commentInput becomeFirstResponder];
        //        };
        //点击回复
//        cell2.clickReplay = ^(NSInteger row,NSInteger index) {
//            GGLog(@"点击了第%ld条回复",index);
//        };
        //查看全部评论
//        cell2.checkAllReplay = ^(NSInteger row) {
//            GGLog(@"点击了查看全部回复");
//        };
        
        cell = (CommentCell *)cell2;
    }
    [cell addBakcgroundColorTheme];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1&&self.commentsArr.count<=0&&!NoPayedNews){
        return 90;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0&&self.newsModel.relatedNews.count) {
        return 30;
    }else if (section == 1){
        if (NoPayedNews) {
            return 230;
        }
        return 30;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0&&self.newsModel.relatedNews.count) {
        headView = [UIView new];
        headView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        title.textAlignment = NSTextAlignmentCenter;
        title.lee_theme.LeeConfigTextColor(@"titleColor");
        UIView *line = [UIView new];
//        line.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        line.backgroundColor = HexColor(#BCD5EE);
        
        [headView sd_addSubviews:@[
                                   title,
                                   line,
                                   ]];
        title.sd_layout
        .centerXEqualToView(headView)
        .centerYEqualToView(headView)
        .heightIs(18)
        ;
        [title setSingleLineAutoResizeWithMaxWidth:100];
        title.text = @"推荐阅读";
        
        line.sd_layout
        .centerXEqualToView(headView)
        .bottomEqualToView(headView)
        .heightIs(4)
        .widthIs(14)
        ;
        [line setSd_cornerRadius:@1];
    }else if (section == 1){
        headView = [UIView new];
        if (NoPayedNews) {
            //添加文本和提示
            UILabel *noticeLabel = [UILabel new];
            noticeLabel.font = PFFontR(15);
            noticeLabel.textColor = RGBA(50, 50, 50, 1);
            noticeLabel.numberOfLines = 0;
            
            UIImageView *lockImg = [UIImageView new];
            
            UILabel *moreNotice = [UILabel new];
            moreNotice.textColor = RGBA(136, 136, 136, 1);
            moreNotice.font = PFFontL(14);
            moreNotice.textAlignment = NSTextAlignmentCenter;
            
            [headView sd_addSubviews:@[
                                       noticeLabel,
                                       moreNotice,
                                       lockImg,
                                       ]];
            noticeLabel.sd_layout
            .leftSpaceToView(headView, 10)
            .rightSpaceToView(headView, 10)
            .topSpaceToView(headView, 10)
            .autoHeightRatio(0)
            ;
            [noticeLabel setMaxNumberOfLinesToShow:4];
            noticeLabel.text = @"本文来自启世录资讯付费文章，覆盖投资精英必读核心资讯，请付费阅读。欢迎关注环球国际时报，实时了解最新资讯。";
            
            moreNotice.sd_layout
            .bottomSpaceToView(headView, 50)
            .leftSpaceToView(headView, 10)
            .rightSpaceToView(headView, 10)
            .heightIs(14)
            ;
            moreNotice.text = @"还有更多精彩内容 付费解锁全文";
            
            lockImg.sd_layout
            .centerXEqualToView(headView)
            .bottomSpaceToView(moreNotice, 10)
            .widthIs(55)
            .heightEqualToWidth()
            ;
            lockImg.image = UIImageNamed(@"new_locked");
            
        }else if(self.newsModel){
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
            if (self.newsModel) {
                NSInteger count = MAX(self.newsModel.commentCount, self.commentsArr.count);
                title.text = [NSString stringWithFormat:@"全部评论（%ld）",count];
            }else{
                title.text = @"全部评论";
            }
        }
        
    }
    
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 1&&self.commentsArr.count<=0&&!NoPayedNews) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 90)];
        footView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        
        UIImageView *imgV = [UIImageView new];
        [footView addSubview:imgV];
        imgV.sd_layout
        .centerXEqualToView(footView)
        .topEqualToView(footView)
        .bottomEqualToView(footView)
        .widthIs(156)
        ;
        imgV.lee_theme.LeeConfigImage(@"noCommentFoot");
        
    }
    
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GGLog(@"tableView点击了");
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        HomePageModel *model = self.newsModel.relatedNews[indexPath.row];
        if (model.itemType>=400&&model.itemType<500) { //投票
            VoteViewController *vVC = [VoteViewController new];
            vVC.newsId = model.itemId;
            [self.navigationController pushViewController:vVC animated:YES];
        }else if (model.itemType>=500&&model.itemType<600) { //问答
            CatechismViewController *cVC = [CatechismViewController new];
            cVC.news_id = model.itemId;
            [self.navigationController pushViewController:cVC animated:YES];
        }else if (model.itemType>=200&&model.itemType<300) {    //专题
            TopicViewController *tVC = [TopicViewController new];
            tVC.topicId = model.itemId;
            [self.navigationController pushViewController:tVC animated:YES];
        }else{
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = model.itemId;
            [self.navigationController pushViewController:ndVC animated:YES];
        }
    }else if (indexPath.section == 1) {
        CompanyCommentModel *model = self.commentsArr[indexPath.row];
        CommentDetailViewController *cdVC = [CommentDetailViewController new];
        cdVC.model = model;
        [self.navigationController pushViewController:cdVC animated:YES];
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    GGLog(@"touchesBegan点击了");
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    //    NSLog(@"touch (x, y) is (%d, %d)", x, y);
//    GGLog(@"y：%lf",self.tableView.contentOffset.y);
//    GGLog(@"-titleViewHeight：%lf",-titleViewHeight);
    
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
                UserInfoViewController *uiVC = [UserInfoViewController new];
                uiVC.userId = self.newsModel.userId;
                [self.navigationController pushViewController:uiVC animated:YES];
            }
        }
    }
    
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    GGLog(@"y:%lf",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= - titleViewHeight&&offsetY <= 0) {
        CGFloat alpha = MIN(1, fabs(offsetY)/(titleViewHeight));
        self.titleView.alpha = alpha;
        self.attentionBtn.enabled = alpha;
        
        if (offsetY >= -20) {
            self.navigationItem.title = GetSaveString(self.newsModel.author);
        }else{
            self.navigationItem.title = @"";
        }
    }
    
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
        
        [HomePageModel saveWithNewsModel:self.newsModel];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取评论列表
-(void)requestComments
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest getWithURLString:ShowComment parameters:parameters success:^(id responseObject) {
        NSArray *arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        if (self.currPage == 1) {
            //            [self.tableView.mj_header endRefreshing];
            if (arr.count) {
                self.commentsArr = [arr mutableCopy];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (arr.count) {
                [self.commentsArr addObjectsFromArray:arr];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self setBottomView];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//回复评论
-(void)requestCommentWithComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    parameters[@"comment"] = comment;
    parameters[@"parentId"] = @(self.parentId);
    
    [HttpRequest postWithTokenURLString:Comments parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        LRToast(@"评论成功~");
        //        self.parentId = 0;
        [self refreshComments];
//        [self requestNewData];
        //        CompanyCommentModel *commentModel = [CompanyCommentModel new];
        //        commentModel.avatar = UserGet(@"avatar");
        //        commentModel.username = UserGet(@"username");
        //        commentModel.comment = comment;
        //        [self.commentsArr
        //         insertObject:commentModel atIndex:0];
        //        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//点赞文章/评论
-(void)requestPraiseWithPraiseType:(NSInteger)praiseType praiseId:(NSInteger)ID commentNum:(NSInteger)row
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(praiseType);
    parameters[@"id"] = @(ID);
    [HttpRequest postWithTokenURLString:Praise parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        
        if (praiseType == 3) {  //新闻
            LRToast(@"点赞成功");
            self.newsModel.hasPraised = !self.newsModel.hasPraised;
            [self setBottomView];
        }else if (praiseType == 2) {
            CompanyCommentModel *model = self.commentsArr[row];
            model.isPraise = !model.isPraise;
            
            if (model.isPraise) {
                LRToast(@"点赞成功");
                model.likeNum ++;
            }else{
                LRToast(@"点赞已取消");
                model.likeNum --;
            }
            [self.tableView reloadData];
        }
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//收藏/取消收藏文章
-(void)requestCollectNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:Favor parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        NSInteger status = [res[@"data"][@"status"] integerValue];
        if (status == 1) {
            LRToast(@"收藏成功");
        }else{
            LRToast(@"已取消收藏");
        }
        self.newsModel.isCollection = status;
        [self setBottomView];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//关注/取消关注
-(void)requestIsAttention
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.newsModel.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        UserModel *user = [UserModel getLocalUserModel];
        NSInteger status = [res[@"data"][@"status"] integerValue];
        if (status == 1) {
            user.followCount ++;
            LRToast(@"关注成功");
        }else{
            user.followCount --;
            LRToast(@"已取消关注");
        }
        self.newsModel.isAttention = status;
        //覆盖之前保存的信息
        [UserModel coverUserData:user];
        [self setTitle];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

-(void)getIsFavorAndIsPraise
{
    [self requestIsFavor];
    [self requestIsPraise];
}

//新闻是否被收藏
-(void)requestIsFavor
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:IsFavor parameters:parameters isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
    } failure:nil RefreshAction:^{
        
    }];
}

//新闻是否被点赞
-(void)requestIsPraise
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"praiseType"] = @(3);
    parameters[@"id"] = @(self.newsId);
    [HttpRequest postWithTokenURLString:IsPraise parameters:parameters isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id res) {
        
    } failure:nil RefreshAction:^{
        
    }];
}

//分享方法
-(void)shareToPlatform:(MGShareToPlateform)type
{
    //创建分享对象
    MGSocialShareModel *shareModel = [MGSocialShareModel new];
    
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
    if (type == MGShareToSina) {
        //如果分享类型是图文，就一定要给图片或者图片链接，无效或为空都是无法分享的
        shareModel.contentType = MGShareContentTypeText;
        shareModel.content = AppendingString(self.newsModel.newsTitle, urlStr);
//        shareModel.thumbImage = [UIImage imageNamed:@""];
//        shareModel.image = @"xxx";
    }else{
        shareModel.contentType = MGShareContentTypeWebPage;
        shareModel.title = self.newsModel.newsTitle;
        shareModel.url = urlStr;
        shareModel.content = self.newsModel.author;
        shareModel.thumbImage = UIImageNamed(@"AppIcon");
        
        if (self.newsModel.images.count>0) {
            shareModel.image = self.newsModel.images[0];
        }
        
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        LRToast(@"分享成功");
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        GGLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
    }];
}

//支付一篇付费文章
-(void)requestPayForNews
{
    [HttpRequest postWithURLString:PayForNews parameters:@{@"newsId":@(self.newsId)} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"支付成功");
        self.newsModel.hasPaid = YES;
        [self setWebViewLoad];
    } failure:^(NSError *error) {
        
    } RefreshAction:^{
        
    }];
}



@end
