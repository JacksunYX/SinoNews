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
@property (nonatomic,strong) UILabel *authorAndTime;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) ZXYShineButton *collectBtn;
@property (nonatomic,strong) UIView *sortView;  //排序视图

@property (nonatomic,strong) UIView *naviTitle;
@end

@implementation CatechismViewController
CGFloat static titleViewHeight = 91;
-(NSMutableArray *)answersArr
{
    if (!_answersArr) {
        _answersArr = [NSMutableArray new];
    }
    return _answersArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];
    
    [self hiddenTopLine];
    
    [self requestNewData];
    
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
        
        _authorAndTime = [UILabel new];
        _authorAndTime.font = PFFontR(11);
        _authorAndTime.textColor = RGBA(152, 152, 152, 1);
        
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
    _tableView.contentInset = UIEdgeInsetsMake(titleViewHeight, 0, 40, 0);
    
    _tableView.contentOffset = CGPointMake(0, -titleViewHeight + 1);
//    [_tableView setContentOffset:CGPointMake(0, -titleViewHeight + 1) animated:YES];
}

-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [UIView new];
        _naviTitle.alpha = 0;
        self.navigationItem.titleView = _naviTitle;
        [_naviTitle addBakcgroundColorTheme];
        
        _naviTitle.sd_layout
        .heightIs(30)
        ;
        
        UIImageView *avatar = [UIImageView new];
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        
        [_naviTitle sd_addSubviews:@[
                                     avatar,
                                     username,
                                     ]];
        CGFloat wid = 0;
        if (self.newsModel.avatar.length>0) {
            wid = 30;
        }
        avatar.sd_layout
        .leftEqualToView(_naviTitle)
        .centerYEqualToView(_naviTitle)
        .widthIs(wid)
        .heightIs(30)
        ;
        [avatar setSd_cornerRadius:@(wid/2)];
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(self.newsModel.avatar))];
        
        username.sd_layout
        .leftSpaceToView(avatar, 5)
        .centerYEqualToView(_naviTitle)
        .heightIs(30)
        ;
        [username setSingleLineAutoResizeWithMaxWidth:150];
        username.text = GetSaveString(self.newsModel.author);
        
        [_naviTitle setupAutoWidthWithRightView:username rightMargin:5];
        
    }
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
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView endUpdates];
        }
    }];
    
    //加载页面
    NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
    GGLog(@"文章h5：%@",urlStr);
    NSURL *url = UrlWithStr(urlStr);
    NSURLRequest *request= [NSURLRequest requestWithURL:url];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:MAXFLOAT];
    [self.webView loadRequest:request];
    [self showOrHideLoadView:YES page:2];
    
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
    
    if (self.collectBtn.selected != self.newsModel.isCollection) {
        self.collectBtn.selected = self.newsModel.isCollection;
    }
    self.praiseBtn.selected = self.newsModel.hasPraised;
    
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
                    [self setWebViewLoad];
                }];
            }else if (row == 1) {
                
                [self.webView reload];
            }else if (row == 2) {
                [self requestCollectNews];
            }else if (row == 3){
                
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
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
//        CGFloat height = [data floatValue];
//        GGLog(@"height:%lf",height);
//    ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
//        设置通知或者代理来传高度
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
    }];
    
    [self setBottomView];
    
    [self setNavigationBtns];
    
    [self setTitle];
    
    [self setNaviTitle];
    
    [self.tableView setContentOffset:CGPointMake(0, -titleViewHeight) animated:YES];
    
    [self showOrHideLoadView:NO page:2];
    
    if (UserGetBool(@"NightMode")) {    //夜间模式
        //修改字体颜色  #9098b8
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#FFFFFF'"completionHandler:nil];
        //修改背景色
        [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#1c2023'" completionHandler:nil];
    }
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
        @strongify(self)
        UserInfoViewController *uiVC = [UserInfoViewController new];
        uiVC.userId = model.userId;
        [self.navigationController pushViewController:uiVC animated:YES];
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
        return 90;
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
    CGFloat offsetY = scrollView.contentOffset.y;
//    GGLog(@"contentOffset.y:%f",offsetY);
    if (offsetY >= - titleViewHeight - 1&&offsetY <= 0) {
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
        }
    }
    
}


#pragma mark ---- 请求发送
//获取回答详情
-(void)requestNewData
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(self.news_id);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        [self setWebViewLoad];
        
        [self.tableView reloadData];
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
