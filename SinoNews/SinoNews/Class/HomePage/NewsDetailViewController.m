//
//  NewsDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) NSInteger page; //页面(起始为1)

@end

@implementation NewsDetailViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getCellHightNotification" object:nil];
    
    [self addTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
//    [self.tableView activateConstraints:^{
//        self.tableView.top_attr = self.view.top_attr_safe;
//        self.tableView.left_attr = self.view.left_attr_safe;
//        self.tableView.right_attr = self.view.right_attr_safe;
//        self.tableView.bottom_attr = self.view.bottom_attr_safe;
//    }];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    
//    WEAK(weakSelf, self);
//    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//
//    }];
//
//    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.page ++;
//
//    }];
    
//    [_tableView.mj_header beginRefreshing];
    
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    NSURL *url = UrlWithStr(@"http://www.baidu.com");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [self.webView loadRequest:request];
//    self.tableView.tableHeaderView = self.webView;
}

-(void)setTableViewCellHight:(NSNotification *)info
{
    NSDictionary * dic = info.userInfo;
    //判断通知中的参数是否与原来的值一致,防止死循环
    if (self.webView.height != [[dic objectForKey:@"height"]floatValue])
    {
        self.webView.height = [[dic objectForKey:@"height"]floatValue];
        self.tableView.tableHeaderView = self.webView;
        [self.tableView reloadData];
    }
}

#pragma mark ----- UIWebViewDelegate
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
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id data, NSError * _Nullable error) {
        CGFloat height = [data floatValue];
        //ps:js可以是上面所写，也可以是document.body.scrollHeight;在WKWebView中前者offsetHeight获取自己加载的html片段，高度获取是相对准确的，但是若是加载的是原网站内容，用这个获取，会不准确，改用后者之后就可以正常显示，这个情况是我尝试了很多次方法才正常显示的
        //设置通知或者代理来传高度
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getCellHightNotification" object:nil userInfo:@{@"height":[NSNumber numberWithFloat:height]}];
    }];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"测试一下";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







@end
