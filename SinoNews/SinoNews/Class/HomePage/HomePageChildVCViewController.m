//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"
#import "NewsDetailViewController.h"

#import "HeadBannerView.h"
#import "ADModel.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"

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
        GGLog(@"选择了下标为%ld的轮播图",index);
        ADModel *model = weakSelf.adArr[index];
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
    
    WEAK(weakSelf, self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_footer.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        weakSelf.page = 1;
        [weakSelf requestNews_list:0];
        [weakSelf requestBanner];
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_header.isRefreshing) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        weakSelf.page ++;
        [weakSelf requestNews_list:1];
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
//    HomePageModel *model = self.dataSource[indexPath.row];
//    if (model.topicId) { //说明是专题
//        HomePageSecondKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
//        cell2.model = model;
//        cell = (UITableViewCell *)cell2;
//    }else{
//        //非专题暂时都用普通cell
//        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
//        cell1.model = model;
//        cell = (UITableViewCell *)cell1;
//    }
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        cell1.model = model;
        cell = (UITableViewCell *)cell1;
    }else if ([model isKindOfClass:[TopicModel class]]){
        HomePageSecondKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
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
        ndVC.newsId = [(HomePageModel *)model news_id];
        [self.navigationController pushViewController:ndVC animated:YES];
    }else if ([model isKindOfClass:[TopicModel class]]){
        
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
    parameters[@"channelId"] = @0;
    parameters[@"loadTime"] = @1525939544;
    
    [HttpRequest getWithURLString:News_list parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *dataArr = [NSMutableArray new];
        for (NSDictionary *dic in responseObject[@"data"]) {
            NSInteger itemType = [dic[@"itemType"] integerValue];
            switch (itemType) {
                case 1: //普通新闻
                {
                    HomePageModel *model = [HomePageModel mj_objectWithKeyValues:dic];
                    [dataArr addObject:model];
                }
                    break;
                case 2: //专题
                {
                    TopicModel *model = [TopicModel mj_objectWithKeyValues:dic];
                    [dataArr addObject:model];
                }
                    break;
                case 3: //广告
                {
                    ADModel *model = [ADModel mj_objectWithKeyValues:dic];
                    [dataArr addObject:model];
                }
                    break;
                    
                default:
                    break;
            }
        }
        if (self.page == 1) {
            self.dataSource = [dataArr mutableCopy];
            [self.tableView.mj_header endRefreshing];
        }else{
            if (dataArr) {
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
        self.adArr = [NSMutableArray arrayWithArray:[ADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        if (!kArrayIsEmpty(self.adArr)) {
            [self creatBanner];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

@end
