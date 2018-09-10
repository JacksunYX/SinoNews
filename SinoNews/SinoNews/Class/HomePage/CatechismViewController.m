//
//  CatechismViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CatechismViewController.h"
#import "CatechismSecondeViewController.h"
#import "Q_APublishViewController.h"

#import "NormalNewsModel.h"

#import "CateChismTableViewCell.h"

#import "ShareAndFunctionView.h"
#import "FontAndNightModeView.h"

@interface CatechismViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *allUrlArray;
    UIScrollView *bgView;
    
    CGFloat currentScrollY; //记录当前滚动的y轴偏移量
    BOOL isLoadWeb; //是否已经加载过网页了
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *answersArr;    //回答数组
@property (nonatomic,assign) NSInteger currPage;            //页面(起始为1)
@property (nonatomic,assign) NSInteger orderBy;             //排序，0热度、1最新

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat topWebHeight;

@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型

@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *authorName;
@property (nonatomic ,strong) UIView *idView;   //认证标签视图
@property (nonatomic,strong) UILabel *creatTime;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;
@property (nonatomic,strong) UIView *sortView;  //排序视图

@property (nonatomic,strong) UIView *naviTitle;

@property (nonatomic,strong) UIButton *topAttBtn; //导航栏上的关注按钮

//新增，封装头部
@property (nonatomic , strong) NewsDetailsHeaderView *headerView;
@end

@implementation CatechismViewController
CGFloat static titleViewHeight = 150;
-(NSMutableArray *)answersArr
{
    if (!_answersArr) {
        _answersArr = [NSMutableArray new];
    }
    return _answersArr;
}

-(UIButton *)topAttBtn
{
    if (!_topAttBtn) {
        _topAttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topAttBtn.frame = CGRectMake(0, 10, 40, 20);
        [_topAttBtn setBtnFont:PFFontM(20)];
        [_topAttBtn setNormalTitleColor:WhiteColor];
        _topAttBtn.backgroundColor = HexColor(#1282EE);
        //        [_topAttBtn setNormalTitle:@"+"];
        _topAttBtn.layer.cornerRadius = 10;
        _topAttBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_topAttBtn addTarget:self action:@selector(requestIsAttention) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topAttBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self configBlock];
    
    [self showOrHideLoadView:YES page:2];
    
    [self hiddenTopLine];
    
    [self requestNewData];
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.headerView updateHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(BaseTableView *)item setSeparatorColor:CutLineColorNight];
        }else{
            [(BaseTableView *)item setSeparatorColor:CutLineColor];
        }
    });
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[CateChismTableViewCell class] forCellReuseIdentifier:CateChismTableViewCellID];
    
    @weakify(self);
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.webView.loading) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.answersArr.count) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestNews_listAnswer];
    }];
    
    [self refreshComments];
    
    _headerView = [[NewsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    self.tableView.tableHeaderView = _headerView;
    
    self.headerView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self.tableView, 1.0f);
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 1;
    [self requestNews_listAnswer];
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
        
        _authorName.sd_layout
        .leftSpaceToView(_avatar, 5)
        .centerYEqualToView(_avatar)
        .heightIs(12)
        ;
        [_authorName setSingleLineAutoResizeWithMaxWidth:150];
        _authorName.text = GetSaveString(self.newsModel.author);
        
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
        .heightIs(12)
        ;
        [_creatTime setSingleLineAutoResizeWithMaxWidth:150];
        _creatTime.text = GetSaveString(self.newsModel.createTime);
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_avatar)
        .widthIs(58)
        .heightIs(20)
        ;
        
        [_attentionBtn setSd_cornerRadius:@10];
        
        [self.titleView setupAutoHeightWithBottomViewsArray:@[_avatar,_attentionBtn] bottomMargin:10];
    }
    
    _attentionBtn.selected = self.newsModel.isAttention;
    if (_attentionBtn.selected) {
        [self.topAttBtn setNormalTitle:@"-"];
        [_attentionBtn setNormalImage:nil];
        [_attentionBtn setSelectedImage:nil];
    }else{
        [self.topAttBtn setNormalTitle:@"+"];
        [_attentionBtn setNormalImage:UIImageNamed(@"myFans_unAttention")];
    }
    
    //如果是用户本人发布的文章，就不显示关注的按钮
    if (![UserModel showAttention:self.newsModel.userId]) {
        [_attentionBtn removeFromSuperview];
        [self.topAttBtn removeFromSuperview];
    }
    
//    _titleLabel.font = [GetCurrentFont titleFont];
    
    //获取上部分的高度
    [self.titleView updateLayout];
    titleViewHeight = self.titleView.height;
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
    
//    _tableView.contentOffset = CGPointMake(0, -titleViewHeight + 1);
//    [_tableView setContentOffset:CGPointMake(0, -titleViewHeight + 1) animated:YES];
}

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    for (UIView *subview in _idView.subviews) {
        [subview removeFromSuperview];
    }
    if (self.newsModel.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = _idView;
        for (int i = 0; i < self.newsModel.identifications.count; i ++) {
            NSDictionary *model = self.newsModel.identifications[i];
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
            if (i == self.newsModel.identifications.count - 1) {
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
        if (self.newsModel.avatar.length>0) {
            wid = 30;
        }
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.newsModel.avatar))];

        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        username.text = GetSaveString(self.newsModel.author);
        [username sizeToFit];
        CGFloat labelW = CGRectGetWidth(username.frame);
        if (labelW>150*ScaleW) {
            labelW = 150*ScaleW;
        }
        username.frame = CGRectMake(CGRectGetMaxX(avatar.frame) + 5, 0, labelW, 30);
        [_naviTitle addSubview:username];
        
        _naviTitle.frame = CGRectMake(0, 0, 5 * 2 + wid + username.width, 30);

        self.navigationItem.titleView = _naviTitle;
    }
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
//    preference.minimumFontSize = [GetCurrentFont contentFont].pointSize;
    
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
    [self.view addSubview:self.webView];
    
    //KVO监听web的高度变化
//    @weakify(self)
//    [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
////        GGLog(@"x:%@",x);
//        CGFloat newHeight = self.webView.scrollView.contentSize.height;
//        if (newHeight != self.topWebHeight) {
//            self.topWebHeight = newHeight;
//            self.webView.frame = CGRectMake(0, 0, ScreenW, self.topWebHeight);
//            //            GGLog(@"topWebHeight:%lf",topWebHeight);
////            [self.tableView beginUpdates];
//            self.tableView.tableHeaderView = self.webView;
////            [self.tableView endUpdates];
//        }
//    }];
    
    /*
    //加载页面
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:MAXFLOAT];
    [self.webView loadRequest:request];
    */
    [self newLoadWeb];
    [self showOrHideLoadView:YES page:2];
    
}

//另一种加载页面的方式
-(void)newLoadWeb
{
    /*
    NSString *color = @"color: #161a24";
    if (UserGetBool(@"NightMode")) {
        color = @"color: #cfd3d6;";
    }
    NSString *styleStr = [NSString stringWithFormat:@"%@line-height:33px;letter-spacing: .8px;",color];
    //调整文字左右对齐
    NSString *styleStr2 = @"text-align:justify; text-justify:inter-ideograph;";
    //拼接样式
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-family:PingFangSC-Regular;font-size:%.fpx;%@%@}\n"
//                       "a {font-weight: 600 !important;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body >"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       //追加定位标签,获取真实高度需要用到
                       "<div id=\"test-div\">"
                       "</div>"
                       "</body>"
                       "</html>",[GetCurrentFont contentFont].pointSize,styleStr,styleStr2,GetSaveString(self.newsModel.fullContent)];
    
    [self.webView loadHTMLString:htmls baseURL:nil];
    
    */
    [self theThirdLoadWebView];
}

//第三种加载方式
-(void)theThirdLoadWebView
{
    NewsDetailsModel *headModel = [NewsDetailsModel new];
    headModel.newsHtml = self.newsModel.fullContent;
    self.headerView.model = headModel;
}

-(void)setNavigationBtns
{
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self action:@selector(moreSelect) image:UIImageNamed(@"news_more_night")];
            
            UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [topBtnView addSubview:self.topAttBtn];
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:topBtnView];
            
            self.navigationItem.rightBarButtonItems = @[more,barbtn];
        }else{
            UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self action:@selector(moreSelect) image:UIImageNamed(@"news_more")];
            
            UIView *topBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            [topBtnView addSubview:self.topAttBtn];
            UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:topBtnView];
            
            self.navigationItem.rightBarButtonItems = @[more,barbtn];
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
        _collectBtn = [ZXYShineButton new];
        UIButton *shareBtn = [UIButton new];
        UIButton *answerInput = [UIButton new];
        
        @weakify(self)
        [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (self.praiseBtn.selected) {
                LRToast(@"已经点过赞啦");
            }else{
                [self requestPraiseWithPraiseType:3 praiseId:self.news_id commentNum:0];
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
        
        _collectBtn.sd_layout
        .rightSpaceToView(shareBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(22)
        ;
        [_collectBtn updateLayout];
        _collectBtn.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            ZXYShineButton *btn = item;
            ZXYShineParams *params = [ZXYShineParams new];
            if (UserGetBool(@"NightMode")) {
                btn.norImg = UIImageNamed(@"news_unCollect_night");
                btn.selImg = UIImageNamed(@"news_collected_night");
                btn.color = HexColor(#cfd3d6);
                btn.fillColor = HexColor(#1282ee);
                params.bigShineColor = HexColor(#1282ee);
                params.smallShineColor = BlueColor;
            }else{
                btn.norImg = UIImageNamed(@"news_unCollect");
                btn.selImg = UIImageNamed(@"news_collected");
                btn.color = HexColor(#1A1A1A);      //未选中时的颜色
                btn.fillColor = HexColor(#ef9f00);  //选中后的填充色
                params.bigShineColor = HexColor(#ef9f00);
                params.smallShineColor = RedColor;
            }
            btn.params = params;
        });
        
        _praiseBtn.sd_layout
        .rightSpaceToView(_collectBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(21)
        ;
        [_praiseBtn updateLayout];
        [_praiseBtn addButtonNormalImage:@"news_unPraise"];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        answerInput.sd_layout
        .leftSpaceToView(self.bottomView, 10)
//        .rightSpaceToView(_praiseBtn, 30)
        .centerYEqualToView(self.bottomView)
        .widthIs(100)
        .heightIs(20)
        ;
        [answerInput updateLayout];
        
        [answerInput setNormalImage:UIImageNamed(@"catechism_addLittle")];
        [answerInput setNormalTitle:@"添加回答..."];
        [answerInput setBtnFont:PFFontL(15)];
        [answerInput setNormalTitleColor:HexColor(#1282EE)];
        [answerInput layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        
        [answerInput whenTap:^{
            @strongify(self)
            Q_APublishViewController *qapVc = [Q_APublishViewController new];
            qapVc.submitBlock = ^{
                self.currPage = 1;
                [self requestNews_listAnswer];
            };
            qapVc.news_id = self.newsModel.newsId;
            UINavigationController *rtVC = [[UINavigationController alloc]initWithRootViewController:qapVc];
            [self presentViewController:rtVC animated:YES completion:nil];
        }];
    }
    
    self.collectBtn.selected = self.newsModel.isCollection;
    self.praiseBtn.selected = self.newsModel.hasPraised;
    
}

#pragma mark - 设置Block
- (void)configBlock{
    
    __weak typeof(self) weakSelf = self;
    
    self.headerView.loadedFinishBlock = ^(BOOL result) {
        
        if (!weakSelf) return ;
        
        if (result) {
            
            weakSelf.tableView.hidden = NO;
            
            weakSelf.tableView.alpha = 0.0f;
            
            [weakSelf setUpOtherViews];
            
            [UIView animateWithDuration:0.5f animations:^{
                
                weakSelf.tableView.alpha = 1.0f;
                [weakSelf showOrHideLoadView:NO page:2];
            }];
            
        } else {
            
            // 加载失败 提示用户
        }
        
    };
    
    self.headerView.updateHeightBlock = ^(NewsDetailsHeaderView *view) {
        
        if (!weakSelf) return ;
        
        weakSelf.tableView.tableHeaderView = view;
    };
    
}

//设置其他视图
-(void)setUpOtherViews
{
    [self setBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
}

//更多
-(void)moreSelect
{
    @weakify(self)
    [ShareAndFunctionView showWithCollect:self.newsModel.isCollection returnBlock:^(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform) {
        @strongify(self)
        if (section == 0) {
            [self shareToPlatform:sharePlateform];
        }else if (section==1) {
            if (row == 0) {
                [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
                    @strongify(self)
                    [self.headerView configFontLevel:fontIndex];
                }];
            }else if (row == 1) {
                [self newLoadWeb];
            }else if (row == 2) {
                [self requestCollectNews];
            }else if (row == 3){
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
                LRToast(@"链接已复制");
            }
            
        }
    }];
}

//排序方式选择视图
-(UIView *)getSortView
{
    if (!self.sortView) {
        CGFloat height = 12;
        self.sortView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 93, height)];
        self.sortView.backgroundColor = HexColor(#F2F6F7);
//        [self.sortView addBakcgroundColorTheme];
        
        UIButton *btn1 = [self getBtn];
        btn1.frame = CGRectMake(0, 0, 45, height);
        [btn1 setTitle:@"热度" forState:UIControlStateNormal];
        btn1.tag = 10010 + 0;
        [btn1 addBorderTo:BorderTypeRight borderColor:HexColor(#3280C7)];
        
        UIButton *btn2 = [self getBtn];
        btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame) + 3, 0, 45, height);
        [btn2 setTitle:@"最新" forState:UIControlStateNormal];
        btn2.tag = 10010 + 1;
        
        [self.sortView sd_addSubviews:@[btn1,btn2]];
    }
    UIButton *btn1 = [self.sortView viewWithTag:10010 + 0];
    UIButton *btn2 = [self.sortView viewWithTag:10010 + 1];
    if (self.orderBy) {
        btn1.selected = NO;
        btn2.selected = YES;
    }else{
        btn1.selected = YES;
        btn2.selected = NO;
    }
    
    return self.sortView;
}

-(UIButton *)getBtn
{
    UIButton *btn = [UIButton new];
    btn.titleLabel.font = PFFontL(12);
    [btn setNormalTitleColor:HexColor(#929697)];
    [btn setSelectedTitleColor:HexColor(#1282EE)];
    [btn addTarget:self action:@selector(sortSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//排序视图点击事件
-(void)sortSelectedAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 10010;
    if (index == self.orderBy) {    //重复点击了
        return;
    }
    self.orderBy = index;
    
    [self requestNews_listAnswer];
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

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [webView evaluateJavaScript:@"document.getElementById(\"test-div\").offsetTop" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
//        GGLog(@"height:%lf",height);
//    ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
//        设置通知或者代理来传高度
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
        self.topWebHeight = height + 10;
        self.webView.frame = CGRectMake(0, 0, ScreenW, self.topWebHeight);
        self.tableView.tableHeaderView = self.webView;
        if (!UserGetBool(@"HaveLoadedWeb")) {
            [self newLoadWeb];
            UserSetBool(YES, @"HaveLoadedWeb");
        }
    }];
    
    [self setBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    CGFloat y = -titleViewHeight;
    if (isLoadWeb) {
        y = currentScrollY;
    }
    //滚到标题偏移坐标
    _tableView.contentOffset = CGPointMake(0, y);
    isLoadWeb = YES;
    
    [self showOrHideLoadView:NO page:2];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
//        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#cfd3d6'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }else{
        //修改字体颜色  #9098b8
//        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#1a1a1a'"completionHandler:nil];
        //修改背景色
//        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#ffffff'" completionHandler:nil];
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
    if ([requestString hasPrefix:@"myweb:imageClick:"]&&!self.webView.loading) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        if (bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            bgView.alpha = 1;
//            NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
//            int i = [imageIndex.lastObject intValue];
//            [bgView setContentOffset:CGPointMake(ScreenW *i, 0)];
//        }else{
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        }
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
-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7]];
    bgView.contentSize = CGSizeMake(ScreenW *allUrlArray.count, bgView.bounds.size.height);
    bgView.pagingEnabled = YES;
    [self.view addSubview:bgView];
    
    //创建显示图像视图
    for (int i = 0; i < allUrlArray.count; i++) {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(ScreenW *i, 0, bgView.bounds.size.width, bgView.bounds.size.height)];
        [bgView addSubview:borderView];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
        imgView.contentMode = 1;
        @weakify(self);
        [imgView whenTap:^{
            @strongify(self);
            [self hiddenBigImage];
        }];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [imgView addSubview:activityIndicator];
        activityIndicator.sd_layout
        .centerXEqualToView(imgView)
        .centerYEqualToView(imgView)
        .widthIs(100)
        .heightEqualToWidth()
        ;
        //设置小菊花颜色
        activityIndicator.color = WhiteColor;
        //设置背景颜色
        activityIndicator.backgroundColor = ClearColor;
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        activityIndicator.hidesWhenStopped = NO;
        [activityIndicator startAnimating];
        
        NSArray *imageIndex = [NSMutableArray arrayWithArray:[allUrlArray[i] componentsSeparatedByString:@"LQXindex"]];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageIndex.firstObject] placeholderImage:nil];
        
        [borderView addSubview:imgView];
        
    }
    NSArray *imageIndex = [NSMutableArray arrayWithArray:[imageUrl componentsSeparatedByString:@"LQXindex"]];
    
    
    int i = [imageIndex.lastObject intValue];
    [bgView setContentOffset:CGPointMake(ScreenW *i, 0)];
    
}

//隐藏图片浏览
-(void)hiddenBigImage
{
    [UIView animateWithDuration:0.5 animations:^{
        self->bgView.alpha = 0;
    }];
}

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
    return self.answersArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CateChismTableViewCell *cell = (CateChismTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CateChismTableViewCellID];
    AnswerModel *model = self.answersArr[indexPath.row];
    cell.model = model;
    @weakify(self)
    //点赞
    cell.praiseBlock = ^{
        @strongify(self)
        if (model.hasPraise) {
            LRToast(@"已经点过赞啦");
        }else{
            [self requestPraiseWithPraiseType:4 praiseId:model.answerId commentNum:indexPath.row];
        }
    };
    //头像
    cell.avatarBlock = ^{
        [UserModel toUserInforVcOrMine:model.userId];
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
    if (section == 0&&self.answersArr.count<=0){
        return 120;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 42;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0) {
        headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 42)];
        headView.backgroundColor = HexColor(#F2F6F7);
        
        UILabel *leftTitle = [UILabel new];
        leftTitle.font = PFFontL(12);
        self.sortView = [self getSortView];
        
        [headView sd_addSubviews:@[
                                   leftTitle,
                                   self.sortView
                                   ]];
        leftTitle.sd_layout
        .leftSpaceToView(headView, 10)
        .centerYEqualToView(headView)
        .heightIs(12)
        ;
        [leftTitle setSingleLineAutoResizeWithMaxWidth:100];
        NSInteger count = MAX(self.newsModel.commentCount, self.answersArr.count);
        if (count) {
            leftTitle.text = [NSString stringWithFormat:@"%ld 回答",count];
        }else{
            leftTitle.text = @"回答";
        }
        
        
        self.sortView.sd_layout
        .rightSpaceToView(headView, 10)
        .centerYEqualToView(headView)
        .widthIs(92)
        .heightIs(12)
        ;
    }
        
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (section == 0&&self.answersArr.count<=0) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
        footView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
        
        UIImageView *imgV = [UIImageView new];
        [footView addSubview:imgV];
        imgV.sd_layout
        .centerXEqualToView(footView)
        .centerYEqualToView(footView)
        //        .topEqualToView(footView)
        //        .bottomEqualToView(footView)
        .widthIs(156)
        .heightIs(90)
        ;
        imgV.lee_theme.LeeConfigImage(@"noCommentFoot");
        
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerModel *model = self.answersArr[indexPath.row];
    CatechismSecondeViewController *csVC = [CatechismSecondeViewController new];
    csVC.answer_id = model.answerId;
    [self.navigationController pushViewController:csVC animated:YES];
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
                [UserModel toUserInforVcOrMine:self.newsModel.userId];
            }
        }
    }
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 传递滑动
    [self.headerView scroll:scrollView.contentOffset];
    
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
        self.topAttBtn.alpha = 0;
        [self hiddenTopLine];
        
    }else{
        if (offsetY>0) {
            [self showTopLine];
            self.naviTitle.alpha = 1;
            self.titleView.alpha = 0;
            self.topAttBtn.alpha = 1;
            self.attentionBtn.enabled = NO;
        }else{
            [self hiddenTopLine];
            self.naviTitle.alpha = 0;
            self.titleView.alpha = 1;
            self.topAttBtn.alpha = 0;
            self.attentionBtn.enabled = YES;
        }
    }
    
}

#pragma mark ---- 请求发送
//获取回答详情
-(void)requestNewData
{
    [self showOrHideLoadView:YES page:2];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.news_id);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self newLoadWeb];
        
        [self.tableView reloadData];
        
//        [self setWebViewLoad];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取回答列表
-(void)requestNews_listAnswer
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.news_id);
    parameters[@"pageNo"] = @(self.currPage);
    parameters[@"orderBy"] = @(self.orderBy);
    [HttpRequest postWithURLString:News_listAnswer parameters:parameters isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSArray *data = [AnswerModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        self.answersArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.answersArr];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    } RefreshAction:nil];
}

//收藏/取消收藏
-(void)requestCollectNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.news_id);
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

//关注/取关
-(void)requestIsAttention
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(self.newsModel.userId);
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
        self.newsModel.isAttention = status;
        //覆盖之前保存的信息
//        [UserModel coverUserData:user];
        [self setTitle];
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
        }else if (praiseType == 4) {
            AnswerModel *model = self.answersArr[row];
            
            NSInteger status = [res[@"data"][@"success"] integerValue];
            if (status) {
                LRToast(@"点赞成功");
                model.hasPraise = YES;
                model.favorCount ++;
            }
            [self.tableView reloadData];
        }
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}



@end
