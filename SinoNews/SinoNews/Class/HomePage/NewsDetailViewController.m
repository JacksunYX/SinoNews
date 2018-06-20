//
//  NewsDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "NewsDetailViewController.h"
#import "HomePageFirstKindCell.h"
#import "NormalNewsModel.h"
#import "CommentCell.h"

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>
{
    CGFloat topWebHeight;
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic,strong) NormalNewsModel *newsModel;    //新闻模型
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) NSInteger currPage;   //页码; //页面(起始为1)
@property (nonatomic,strong) UIView *titleView;
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
    
    @weakify(self);
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
    
    [self addTableView];
    
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
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [_tableView updateLayout];
    _tableView.backgroundColor = ClearColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 38, 0, 10);
    _tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
    _tableView.enableDirection = YES;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[CommentCell class] forCellReuseIdentifier:CommentCellID];
    
    
    @weakify(self);
//    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_header endRefreshing];
//            return ;
//        }
//        self.currPage = 1;
//        [self requestComments];
//    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (!self.commentsArr.count) {
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
    preference.minimumFontSize = 27;
    
    //创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = wkUController;
//    // 设置偏好设置对象
//    config.preferences = preference;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0) configuration:config];
    self.webView.navigationDelegate = self;
    //监听web的高度变化
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)refreshComments
{
    self.currPage = 1;
    [self requestComments];
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
        
        UIButton *attentionBtn = [UIButton new];
        [attentionBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        attentionBtn.backgroundColor = RGBA(18, 130, 238, 1);
        
        attentionBtn.titleLabel.font = PFFontR(13);
        
        [self.titleView sd_addSubviews:@[
                                         title,
                                         icon,
                                         authorAndTime,
                                         attentionBtn,
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
        
        attentionBtn.sd_layout
        .rightSpaceToView(_titleView, 10)
        .centerYEqualToView(_titleView)
        .widthIs(58)
        .heightIs(20)
        ;
        [attentionBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [attentionBtn setSd_cornerRadius:@8];
    }
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
        cell2.model = self.commentsArr[indexPath.row];
        //点赞
        cell2.praiseBlock = ^(NSInteger row) {
            GGLog(@"点赞");
        };
        //回复TA
        cell2.replayBlock = ^(NSInteger row) {
            GGLog(@"点击了回复TA");
        };
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
    }else if (section == 1){
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= -80&&offsetY <= 0) {
//        if (scrollView.direction == DirectionUp) {
////            GGLog(@"111");
//            CGFloat alpha = MIN(1, fabs(offsetY)/(80));
//            self.titleView.alpha = alpha;
//        }else{
////            GGLog(@"222");
//            CGFloat alpha = MIN(1, fabs(offsetY)/(80));
//            self.titleView.alpha = alpha;
//        }
        CGFloat alpha = MIN(1, fabs(offsetY)/(80));
        self.titleView.alpha = alpha;
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
    parameters[@"newsId"] = @(1);
    
    [HttpRequest getWithURLString:BrowseNews parameters:parameters success:^(id responseObject) {
        self.newsModel = [NormalNewsModel mj_objectWithKeyValues:responseObject[@"data"]];
        NSString *urlStr = ApiAppending(self.newsModel.freeContentUrl);
        GGLog(@"文章h5：%@",urlStr);
//        NSURL *url = UrlWithStr(urlStr);
        NSURL *url = UrlWithStr(@"http://www.bilibili.com");
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
        [self.webView loadRequest:request];
        [self setTitle];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

//获取评论列表
-(void)requestComments
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"newsId"] = @(1);
    parameters[@"currPage"] = @(self.currPage);
    [HttpRequest getWithURLString:ShowComment parameters:parameters success:^(id responseObject) {
        NSArray *arr = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        if (self.currPage == 1) {
            self.commentsArr = [arr mutableCopy];
            [self.tableView.mj_header endRefreshing];
        }else{
            if (arr.count) {
                [self.commentsArr addObjectsFromArray:arr];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


@end
