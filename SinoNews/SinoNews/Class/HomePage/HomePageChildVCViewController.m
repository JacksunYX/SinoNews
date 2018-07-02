//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"
#import "NewsDetailViewController.h"
#import "TopicViewController.h"
#import "PayNewsViewController.h"

#import "HeadBannerView.h"
#import "ADModel.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"
#import "HomePageFourthCell.h"

#define HeadViewHeight (ScreenW * 9 / 16 + 15)

@interface HomePageChildVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *adArr; //广告数组
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page; //页面(起始为1)
@end

@implementation HomePageChildVCViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTableView];
    
    self.view.backgroundColor = WhiteColor;
//    GGLog(@"news_id:%@",self.news_id);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//测试轮播图
-(void)creatBanner
{
    HeadBannerView *headView = [HeadBannerView new];
    
    [self.view addSubview:headView];
    
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(HeadViewHeight)
    ;
    [headView updateLayout];
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (int i = 0; i < self.adArr.count; i ++) {
        ADModel *model = self.adArr[i];
        [imgs addObject:model.url];
    }
    [headView setupUIWithImageUrls:imgs];
    
    WEAK(weakSelf, self);
    headView.selectBlock = ^(NSInteger index) {
        ADModel *model = weakSelf.adArr[index];
        GGLog(@"跳转地址：%@",model.redirectUrl);
        [[UIApplication sharedApplication] openURL:UrlWithStr(model.redirectUrl)];
    };
    
    self.tableView.tableHeaderView = headView;
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
    [_tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    
    @weakify(self)
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        self.page = 1;
        [self requestNews_list:0];
        if ([self.news_id integerValue] == 82) {
            [self requestBanner];
        }
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        self.page ++;
        [self requestNews_list:1];
    }];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = (HomePageModel *)model;
        switch (model1.itemType) {
            case 100:   //无图
            {
                HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
            case 101:   //1图
            {
                HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
            case 103:   //3图
            {
                HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
                
            default:
                break;
        }

    }else if ([model isKindOfClass:[TopicModel class]]){
        HomePageFirstKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        cell2.model = model;
        cell = (UITableViewCell *)cell2;
    }else if ([model isKindOfClass:[ADModel class]]){
        HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
        cell3.model = model;
        cell = (UITableViewCell *)cell3;
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
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[HomePageModel class]]) {
        NewsDetailViewController *ndVC = [NewsDetailViewController new];
//        ndVC.newsId = [(HomePageModel *)model news_id];
        ndVC.newsId = 118;
        [self.navigationController pushViewController:ndVC animated:YES];
        
//        PayNewsViewController *pnVC = [PayNewsViewController new];
//        [self.navigationController pushViewController:pnVC animated:YES];
        
    }else if ([model isKindOfClass:[TopicModel class]]){
        TopicViewController *tVC = [TopicViewController new];
        tVC.model = model;
        [self.navigationController pushViewController:tVC animated:YES];
    }else if ([model isKindOfClass:[ADModel class]]){
        
    }

}

#pragma mark ---- 请求方法
//请求文章列表(上拉或下拉)
-(void)requestNews_list:(NSInteger)upOrDown
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    parameters[@"channelId"] = @([GetSaveString(self.news_id) integerValue]);
//    parameters[@"loadTime"] = @([[NSString currentTimeStr] longLongValue]);
    
    parameters[@"page"] = @(self.page);
    parameters[@"loadType"] = @(upOrDown);
    parameters[@"channelId"] = @([self.news_id integerValue]);
    parameters[@"loadTime"] = @0;
    
    [HttpRequest getWithURLString:News_list parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *dataArr = [NSMutableArray new];
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSInteger itemType = [dic[@"itemType"] integerValue];
            if (itemType>=100&&itemType<200) {  //新闻
                HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }else if (itemType>=200&&itemType<300) {    //专题
                TopicModel *model = [TopicModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }else if (itemType>=300&&itemType<400){     //广告
                ADModel *model = [ADModel mj_objectWithKeyValues:dic];
                [dataArr addObject:model];
            }
        }
        if (self.page == 1) {
            self.dataSource = [dataArr mutableCopy];
            [self.tableView.mj_header endRefreshing];
        }else{
            if (dataArr.count) {
                [self.dataSource addObjectsFromArray:dataArr];
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

//请求banner
-(void)requestBanner
{
    [HttpRequest getWithURLString:Adverts parameters:@{@"advertsPositionId":@1} success:^(id responseObject) {
        self.adArr = [NSMutableArray arrayWithArray:[ADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"advertsList"]]];
        if (!kArrayIsEmpty(self.adArr)) {
            //只有第一个才加载banner
            [self creatBanner];
            
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

@end
