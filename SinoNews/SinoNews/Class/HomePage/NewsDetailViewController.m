//
//  NewsDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "NewsDetailViewController.h"
#import "CommentDetailViewController.h"
#import "HomePageFirstKindCell.h"
#import "NormalNewsModel.h"
#import "CommentCell.h"

#import "FontAndNightModeView.h"
#import "ShareAndFunctionView.h"


@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    CGFloat topWebHeight;
    
}
@property (nonatomic,strong) UITextField *commentInput;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) NSInteger currPage;   //页码; //页面(起始为1)
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *collectBtn;

@property (nonatomic,assign) NSInteger parentId;

@end

@implementation NewsDetailViewController

-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [self addNavigationView];
    
    [self addTableView];
    
    [self showOrHideLoadView:YES page:2];
    
    [self requestNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//修改导航栏显示
-(void)addNavigationView
{
    UIBarButtonItem *more = [UIBarButtonItem itemWithTarget:self Action:@selector(moreSelect) image:@"news_more" hightimage:nil andTitle:@""];
    UIBarButtonItem *fonts = [UIBarButtonItem itemWithTarget:self Action:@selector(fontsSelect) image:@"news_fonts" hightimage:nil andTitle:@""];
    self.navigationItem.rightBarButtonItems = @[more,fonts];
    
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
        .heightIs(47)
        ;
        
        self.commentInput = [UITextField new];
        self.commentInput.delegate = self;
        self.commentInput.returnKeyType = UIReturnKeySend;
        @weakify(self)
        [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            GGLog(@"完成编辑");
            UITextField *field = x.first;
            GGLog(@"-----%@",field.text);
            [field resignFirstResponder];
            if ([NSString isEmpty:field.text]) {
                LRToast(@"评论不能为空哦~");
            }else{
                [self requestCommentWithComment:field.text];
                field.text = @"";
            }
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
            [self requestCollectNews];
        }];
        
        [[shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
        }];
        
        [self.bottomView sd_addSubviews:@[
                                          shareBtn,
                                          _collectBtn,
                                          _praiseBtn,
                                          self.commentInput,
                                          ]];
        
        shareBtn.sd_layout
        .rightSpaceToView(self.bottomView, 14)
        .centerYEqualToView(self.bottomView)
        .widthIs(23)
        .heightIs(19)
        ;
        [shareBtn setImage:UIImageNamed(@"news_share") forState:UIControlStateNormal];
        
        _collectBtn.sd_layout
        .rightSpaceToView(shareBtn, 12)
        .centerYEqualToView(self.bottomView)
        .widthIs(24)
        .heightIs(23)
        ;
        [_collectBtn setImage:UIImageNamed(@"news_unCollect") forState:UIControlStateNormal];
        [_collectBtn setImage:UIImageNamed(@"news_collected") forState:UIControlStateSelected];
        
        _praiseBtn.sd_layout
        .rightSpaceToView(_collectBtn, 13)
        .centerYEqualToView(self.bottomView)
        .widthIs(22)
        .heightIs(20)
        ;
        [_praiseBtn setImage:UIImageNamed(@"news_unpraise") forState:UIControlStateNormal];
        [_praiseBtn setImage:UIImageNamed(@"news_praised") forState:UIControlStateSelected];
        
        self.commentInput.sd_layout
        .leftSpaceToView(self.bottomView, 35)
        .rightSpaceToView(_praiseBtn, 16)
        .centerYEqualToView(self.bottomView)
        .heightIs(33)
        ;
        self.commentInput.backgroundColor = RGBA(238, 238, 238, 1);
        [self.commentInput setSd_cornerRadius:@16];
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
        
    }
    
    self.collectBtn.selected = self.newsModel.isCollection;
    self.praiseBtn.selected = self.newsModel.hasPraised;
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    //    .bottomSpaceToView(self.bottomView, 0)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 48)
    ;
    [_tableView updateLayout];
    _tableView.backgroundColor = ClearColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 38, 0, 10);
    _tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    _tableView.enableDirection = YES;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    
    @weakify(self);
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.webView.loading) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        self.currPage ++;
        [self requestComments];
    }];
    
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
    config.userContentController = wkUController;
    //    // 设置偏好设置对象
    config.preferences = preference;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0) configuration:config];
    self.webView.navigationDelegate = self;
    //监听web的高度变化
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"getCellHightNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        NSDictionary * dic = x.userInfo;
        //判断通知中的参数是否与原来的值一致,防止死循环
        if (self.webView.height != [[dic objectForKey:@"height"]floatValue])
        {
            self.webView.height = [[dic objectForKey:@"height"]floatValue];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView reloadData];
        }
    }];
}

-(void)setTitle
{
    if (!self.titleView) {
        self.titleView = [UIView new];
        self.titleView.backgroundColor = WhiteColor;
        [self.view insertSubview:self.titleView belowSubview:self.tableView];
        self.titleView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        .heightIs(80)
        ;
        
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        title.numberOfLines = 2;
        
        UIImageView *icon = [UIImageView new];
        icon.backgroundColor = Arc4randomColor;
        
        UILabel *authorAndTime = [UILabel new];
        authorAndTime.font = PFFontR(11);
        authorAndTime.textColor = RGBA(152, 152, 152, 1);
        
        @weakify(self);
        _attentionBtn = [UIButton new];
        [_attentionBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        _attentionBtn.backgroundColor = RGBA(18, 130, 238, 1);
        [[_attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self requestIsAttention];
        }];
        
        _attentionBtn.titleLabel.font = PFFontR(13);
        
        [self.titleView sd_addSubviews:@[
                                         title,
                                         icon,
                                         authorAndTime,
                                         _attentionBtn,
                                         ]];
        title.sd_layout
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .topEqualToView(self.titleView)
        .heightIs(39)
        ;
        title.text = GetSaveString(self.newsModel.newsTitle);
        
        icon.sd_layout
        .leftEqualToView(title)
        .topSpaceToView(title, 7)
        .widthIs(24)
        .heightEqualToWidth()
        ;
        [icon setSd_cornerRadius:@12];
        
        authorAndTime.sd_layout
        .leftSpaceToView(icon, 3)
        .centerYEqualToView(icon)
        .heightIs(12)
        ;
        [authorAndTime setSingleLineAutoResizeWithMaxWidth:200];
        authorAndTime.text = [NSString stringWithFormat:@"%@    %@",GetSaveString(self.newsModel.author),GetSaveString(self.newsModel.createTime)];
        
        _attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(icon)
        .widthIs(58)
        .heightIs(20)
        ;
        [_attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn setSd_cornerRadius:@8];
    }
    _attentionBtn.selected = self.newsModel.isAttention;
}

//刷新评论
-(void)refreshComments
{
    self.currPage = 0;
    [self.tableView.mj_footer beginRefreshing];
}

//更多
-(void)moreSelect
{
    if (!self.newsModel) {
        return;
    }
    @weakify(self)
    [ShareAndFunctionView showWithCollect:self.newsModel.isCollection returnBlock:^(NSInteger section, NSInteger row) {
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
        }else if (section==1&&row==2) {
            [self requestCollectNews];
        }
    }];
}

//字体
-(void)fontsSelect
{
    [FontAndNightModeView show:^(BOOL open, NSInteger fontIndex) {
        
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat newHeight = self.webView.scrollView.contentSize.height;
        if (newHeight > topWebHeight) {
            topWebHeight = newHeight;
            self.webView.frame = CGRectMake(0, 0, ScreenW, topWebHeight);
            //            GGLog(@"topWebHeight:%lf",topWebHeight);
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView endUpdates];
        }
    }
}

#pragma mark ----- UIWebViewDelegattopWebHeighte
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    //此方法获取webview的内容高度（建议使用）
//    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue];
//    //设置通知或者代理来传高度
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//
//    [self.webView reload];
//}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self refreshComments];
    [self showOrHideLoadView:NO page:2];
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        //        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        //设置通知或者代理来传高度
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
    }];
    
    //修改字体大小 300%
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    
    //修改字体颜色  #9098b8
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#323232'"completionHandler:nil];
    //修改背景色
    //    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='#2E2E2E'" completionHandler:nil];
    
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
        HomePageFirstKindCell *cell0 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        cell0.model = self.newsModel.relatedNews[indexPath.row];
        cell = (UITableViewCell *)cell0;
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
        //回复TA
        //        cell2.replayBlock = ^(NSInteger row) {
        //            @strongify(self)
        //            self.parentId = [model.commentId integerValue];
        //            [self.commentInput becomeFirstResponder];
        //        };
        //点击回复
        cell2.clickReplay = ^(NSInteger row,NSInteger index) {
            GGLog(@"点击了第%ld条回复",index);
        };
        //查看全部评论
        cell2.checkAllReplay = ^(NSInteger row) {
            GGLog(@"点击了查看全部回复");
        };
        
        cell = (CommentCell *)cell2;
    }
    
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
    if (section == 0&&self.newsModel.relatedNews.count) {
        return 30;
    }else if (section == 1){
        return 30;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    headView.backgroundColor = WhiteColor;
    if (section == 0&&self.newsModel.relatedNews.count) {
        UILabel *title = [UILabel new];
        title.font = PFFontR(16);
        title.textAlignment = NSTextAlignmentCenter;
        UIView *line = [UIView new];
        line.backgroundColor = RGBA(188, 213, 238, 1);
        
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
    }else if (section == 1&&self.newsModel){
        UILabel *title = [UILabel new];
        title.font = PFFontR(13);
        [headView addSubview:title];
        //布局
        title.sd_layout
        .centerYEqualToView(headView)
        .leftSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        if (self.newsModel) {
            title.text = [NSString stringWithFormat:@"全部评论（%lu）",self.newsModel.commentCount];
        }else{
            title.text = @"全部评论";
        }
    }
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GGLog(@"tableView点击了");
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        NewsDetailViewController *ndVC = [NewsDetailViewController new];
//        HomePageModel *model = self.newsModel.relatedNews[indexPath.row];
//        ndVC.newsId = [(HomePageModel *)model news_id];
        ndVC.newsId = 118;
        [self.navigationController pushViewController:ndVC animated:YES];
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
    if (self.attentionBtn.enabled) {
        if (self.tableView.contentOffset.y > -80) {
            //            GGLog(@"不能点击");
        }else{
            //            GGLog(@"点击了关注周围");
            if (x >= ScreenW - (58+10)&&x<= ScreenW - 10 && y >= 48 && y <= 68) {
                //                GGLog(@"点击了关注");
                [self requestIsAttention];
            }
        }
    }
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= -80&&offsetY <= 0) {
        CGFloat alpha = MIN(1, fabs(offsetY)/(80));
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
        if (!self.webView.URL.absoluteString) {
            NSString *urlStr = AppendingString(DefaultDomainName, self.newsModel.freeContentUrl);
            GGLog(@"文章h5：%@",urlStr);
            NSURL *url = UrlWithStr(urlStr);
            //        NSURL *url = UrlWithStr(@"http://www.bilibili.com");
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
            [self.webView loadRequest:request];
        }
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
        [self setTitle];
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
        [self requestNewData];
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
        self.newsModel.isCollection = !self.newsModel.isCollection;
        if (self.newsModel.isCollection) {
            LRToast(@"收藏成功～");
        }else{
            LRToast(@"已取消收藏");
        }
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
        self.newsModel.isAttention = !self.newsModel.isAttention;
        if (self.newsModel.isAttention) {
            LRToast(@"关注成功～");
        }else{
            LRToast(@"已取消关注");
        }
        [self setTitle];
    } failure:nil RefreshAction:^{
        [self requestNewData];
    }];
}

//分享
-(void)shareView
{
    
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
        shareModel.content = @"";
        shareModel.thumbImage = [UIImage imageNamed:@""];
    }
    
    //分享
    [[MGSocialShareHelper defaultShareHelper]  shareMode:shareModel toSharePlatform:type showInController:self successBlock:^{
        NSLog(@"分享成功");
    } failureBlock:^(MGShareResponseErrorCode errorCode) {
        NSLog(@"分享失败---- errorCode = %lu",(unsigned long)errorCode);
        
    }];
}



@end
