//
//  PayNewsViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/28.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PayNewsViewController.h"

@interface PayNewsViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,UIScrollViewDelegate>
{
    CGFloat topWebHeight;
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIView *titleView;

@property (nonatomic,strong) UIView *bottomView;
@end

static CGFloat topHeight = 235;

@implementation PayNewsViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
        
        self.tableView.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN + 40)
        ;
        [_tableView updateLayout];
        _tableView.backgroundColor = ClearColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 38, 0, 10);
        _tableView.contentInset = UIEdgeInsetsMake(topHeight, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSelectionStyleGray;
        
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle];
    
    [self setBottomView];
    
    [self loadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
        .heightIs(topHeight)
        ;
        
        UIImageView *topBanner = [UIImageView new];
        
        UILabel *title = [UILabel new];
        title.font = PFFontL(18);
        title.numberOfLines = 2;
        
        UIImageView *icon = [UIImageView new];
        icon.backgroundColor = Arc4randomColor;
        
        UILabel *authorAndTime = [UILabel new];
        authorAndTime.font = PFFontR(11);
        authorAndTime.textColor = RGBA(152, 152, 152, 1);
        
        [self.titleView sd_addSubviews:@[
                                         topBanner,
                                         title,
                                         icon,
                                         authorAndTime,
                                         ]];
        topBanner.sd_layout
        .topEqualToView(self.titleView)
        .leftEqualToView(self.titleView)
        .rightEqualToView(self.titleView)
        .heightIs(125)
        ;
        topBanner.image = UIImageNamed(@"paynews_banner1");
        
        title.sd_layout
        .topSpaceToView(topBanner, 25)
        .leftSpaceToView(self.titleView, 10)
        .rightSpaceToView(self.titleView, 10)
        .heightIs(18)
        ;
        title.text = @"朝美领导人历史性会晤朝美领导人历史性会晤朝美领导人历史性会晤朝美领导人历史性会晤";
        
        icon.sd_layout
        .leftEqualToView(title)
        .bottomSpaceToView(self.titleView, 20)
        .widthIs(26)
        .heightEqualToWidth()
        ;
        [icon setSd_cornerRadius:@13];
        icon.image = UIImageNamed(@"userIcon");
        
        authorAndTime.sd_layout
        .leftSpaceToView(icon, 3)
        .centerYEqualToView(icon)
        .heightIs(12)
        ;
        [authorAndTime setSingleLineAutoResizeWithMaxWidth:200];
        authorAndTime.text = @"环球国际时报   05/23   16:28";
        
    }
    
}

-(void)setBottomView
{
    if (!self.bottomView) {
        self.bottomView = [UIView new];
        self.bottomView.backgroundColor = WhiteColor;
        [self.view addSubview:self.bottomView];
        self.bottomView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, BOTTOM_MARGIN)
        .heightIs(40)
        ;
        [self.bottomView updateLayout];

        UIButton *payBtn = [UIButton new];
        payBtn.backgroundColor = RGBA(18, 130, 238, 1);
        payBtn.titleLabel.font = PFFontL(15);
        [payBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [payBtn setTitle:@"购买" forState:UIControlStateNormal];
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.font = PFFontR(16);
        priceLabel.textColor = RGBA(18, 130, 238, 1);
        priceLabel.text = @"  ¥199.00";
        
        [self.bottomView sd_addSubviews:@[
                                          payBtn,
                                          priceLabel,
                                          ]];
        payBtn.sd_layout
        .topEqualToView(self.bottomView)
        .rightEqualToView(self.bottomView)
        .bottomEqualToView(self.bottomView)
        .widthIs(95)
        ;
        [payBtn updateLayout];
        
        priceLabel.sd_layout
        .topEqualToView(self.bottomView)
        .leftEqualToView(self.bottomView)
        .rightSpaceToView(payBtn, 0)
        .bottomEqualToView(self.bottomView)
        ;
        [priceLabel updateLayout];
        [priceLabel addBorderTo:BorderTypeTop borderColor:RGBA(227, 227, 227, 1)];
    }
}

-(void)loadWebView
{
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

    @weakify(self)
    //KVO监听web的高度变化
    [RACObserve(self.webView.scrollView, contentSize) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
//        GGLog(@"x:%@",x);
        CGFloat newHeight = self.webView.scrollView.contentSize.height;
        if (newHeight != self->topWebHeight) {
            self->topWebHeight = newHeight;
            self.webView.frame = CGRectMake(0, 0, ScreenW, self->topWebHeight);
            //            GGLog(@"topWebHeight:%lf",topWebHeight);
            [self.tableView beginUpdates];
            self.tableView.tableHeaderView = self.webView;
            [self.tableView endUpdates];
        }
    }];
    
    NSURL *url = UrlWithStr(@"http://192.168.2.142:8087/v1.0.1/api/news/content/?paid=0&id=118");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [self.webView loadRequest:request];
}

#pragma mark ----- WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
//    [self showOrHideLoadView:NO page:2];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
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
        return 230;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (section == 0&& self.webView.isLoading == NO) {
        headView = [UIView new];
        headView.backgroundColor = WhiteColor;
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
    }
    
    return headView;
}





@end
