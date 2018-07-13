//
//  RankDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankListViewController.h"
#import "GroupShadowTableView.h"
#import "RankListTableViewCell.h"
#import "RankDetailViewController.h"

@interface RankListViewController ()<GroupShadowTableViewDelegate,GroupShadowTableViewDataSource,UITableViewDataSource,UITableViewDelegate>
//@property (strong, nonatomic) GroupShadowTableView *tableView;
@property (strong, nonatomic) BaseTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currPage;   //页码
@end

@implementation RankListViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
//        NSArray *userIcon = @[
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              @"user_icon",
//                              ];
//        NSArray *title = @[
//                           @"儿童娱乐场",
//                           @"成人娱乐场",
//                           @"测试娱乐场",
//                           @"竞技娱乐场",
//                           @"贪玩娱乐场",
//                           @"中老年娱乐场",
//                           @"猛男娱乐场",
//                           @"淑女娱乐场",
//                           @"混搭娱乐场",
//                           @"血战娱乐场",
//                           ];
//        NSArray *score = @[
//                           @"99.9 分",
//                           @"99.5 分",
//                           @"99.1 分",
//                           @"97.0 分",
//                           @"96.5 分",
//                           @"94.5 分",
//                           @"90.0 分",
//                           @"88.5 分",
//                           @"85.5 分",
//                           @"82.5 分",
//                           ];
//
//        NSArray *subTitle = @[
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              @"首存送100奖金",
//                              ];
//        NSArray *upOrDown = @[
//                              @1,
//                              @1,
//                              @1,
//                              @0,
//                              @0,
//                              @0,
//                              @1,
//                              @0,
//                              @1,
//                              @0,
//                              ];
//        for (int i = 0; i < userIcon.count; i ++) {
//            NSMutableDictionary *dic = [NSMutableDictionary new];
//            dic[@"userIcon"] = userIcon[i];
//            dic[@"title"] = title[i];
//            dic[@"score"] = score[i];
//            dic[@"subTitle"] = subTitle[i];
//            dic[@"upOrDown"] = upOrDown[i];
//            [_dataSource addObject:dic];
//        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBaseViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addBaseViews
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.showSeparator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [self.tableView updateLayout];
    
    [self.tableView registerClass:[RankListTableViewCell class] forCellReuseIdentifier:RankListTableViewCellID];
    
    WEAK(weakSelf, self);
    self.tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_footer.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }
        weakSelf.currPage = 1;
        [weakSelf requestCompanyRanking];
    }];
//    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
//        if (weakSelf.tableView.mj_header.isRefreshing) {
//            [weakSelf.tableView.mj_footer endRefreshing];
//            return ;
//        }
//        weakSelf.currPage ++;
//        [weakSelf requestCompanyRanking];
//    }];
    
    [self.tableView.mj_header beginRefreshing];
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
    RankListTableViewCell *cell = (RankListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RankListTableViewCellID];
    RankingListModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    cell.toPlayBlock = ^{
        [[UIApplication sharedApplication] openURL:UrlWithStr(model.companyUrl)];
    };
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    if (indexPath.row<3) {
        return 100;
    }
    return 73;
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
    RankDetailViewController *rdVC = [RankDetailViewController new];
    RankingListModel *model = self.dataSource[indexPath.row];
    rdVC.companyId = model.companyId;
    
    [self.navigationController pushViewController:rdVC animated:YES];
}


//暂弃
#pragma mark ----- GroupShadowTableViewDataSource
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return 4;
}

- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 3&&self.dataSource.count>=3) {
        return 1;
    }
    return self.dataSource.count - 3;
}

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankListTableViewCell *cell = (RankListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RankListTableViewCellID];
    NSInteger num = 0;
    if (indexPath.section < 3) {
        num = indexPath.section;
    }else{
        num = indexPath.row + 3;
    }
    cell.tag = num + 1;
    cell.model = self.dataSource[num];
    return cell;
    
}

#pragma mark ----- GroupShadowTableViewDelegate
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3) {
        return 84;
    }
    return 72;
}

- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RankDetailViewController *rdVC = [RankDetailViewController new];
    NSInteger num = 0;
    if (indexPath.section < 3) {
        num = indexPath.section;
    }else{
        num = indexPath.row + 3;
    }
    RankingListModel *model = self.dataSource[num];
    rdVC.companyId = model.companyId;
    
    [self.navigationController pushViewController:rdVC animated:YES];
}


#pragma mark ----- 


//请求详细榜单
-(void)requestCompanyRanking
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"rankingId"] = GetSaveString(self.rankingId);
//    parameters[@"currPage"] = @(self.currPage);
   
    [HttpRequest getWithURLString:CompanyRanking parameters:parameters success:^(id responseObject) {
        NSArray *data = [RankingListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        if (self.currPage == 1) {
            self.dataSource = [data mutableCopy];
            [self endRefresh];
        }else{
            if (data.count) {
                [self.dataSource addObjectsFromArray:data];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
    
}

-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}








@end
