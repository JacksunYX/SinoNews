//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"
#import "BaseTableView.h"
#import "HeadBannerView.h"
#import "ADModel.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"

#define HeadViewHeight (ScreenW * 9 / 16 + 15)

@interface HomePageChildVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *adArr; //广告数组
@end

@implementation HomePageChildVCViewController

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
//        [weakSelf requestNews_list];
        [weakSelf requestBanner];
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        cell = (UITableViewCell *)cell1;
    }
    
    if (indexPath.row == 1) {
        HomePageSecondKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
        cell = (UITableViewCell *)cell2;
    }
    
    if (indexPath.row == 2) {
        HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
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

#pragma mark ---- 请求方法
//请求文章列表
-(void)requestNews_list
{
    [HttpRequest getWithURLString:[News_list stringByAppendingString:[NSString stringWithFormat:@"%@",GetSaveString(self.news_id)]] parameters:nil success:^(id responseObject) {
        
    } failure:nil];
    [self.tableView.mj_header endRefreshing];
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
    } failure:nil];
    
}

@end
