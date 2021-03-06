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
    
    [self addNavigationView];
    
    [self addBaseViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *rightImg = @"attention_search";
        
        if (UserGetBool(@"NightMode")) {
            rightImg = [rightImg stringByAppendingString:@"_night"];
            
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(rightImg)];
    });
    
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
    
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        BaseTableView *tableview = item;
        tableview.backgroundColor = value;
        if (UserGetBool(@"NightMode")) {
            tableview.separatorColor = CutLineColorNight;
        }else{
            tableview.separatorColor = CutLineColor;
        }
    });
    
    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, 0)
    ;
    [self.tableView updateLayout];
    
    [self.tableView registerClass:[RankListTableViewCell class] forCellReuseIdentifier:RankListTableViewCellID];
    [self.tableView registerClass:[RankListTableViewCell2 class] forCellReuseIdentifier:RankListTableViewCell2ID];
    
    _currPage = 1;
    WEAK(weakSelf, self);
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        if (weakSelf.tableView.mj_footer.isRefreshing) {
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }
        weakSelf.currPage = 1;
        [weakSelf requestCompanyRankingWithCompanyName:nil];
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

-(void)searchAction
{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入要搜索的公司" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //回调搜索
        [searchViewController dismissViewControllerAnimated:NO completion:nil];
        [self requestCompanyRankingWithCompanyName:searchText];
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
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
    RankListTableViewCell2 *cell = (RankListTableViewCell2 *)[tableView dequeueReusableCellWithIdentifier:RankListTableViewCell2ID];
    cell.tag = indexPath.row;
    cell.model = self.dataSource[indexPath.row];
    
    @weakify(self);
    cell.toPlayBlock = ^(NSInteger index){
        @strongify(self);
        RankingListModel *model = self.dataSource[index];
        [[UIApplication sharedApplication] openURL:UrlWithStr([NSString deleteHeadAndFootSpace:model.website])];
    };
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
//    RankingListModel *model = self.dataSource[indexPath.row];
//    if (model.currentRank<4) {
//        return 100;
//    }
//    return 73;
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
-(void)requestCompanyRankingWithCompanyName:(NSString *)companyname
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"rankingId"] = GetSaveString(self.rankingId);
//    parameters[@"currPage"] = @(self.currPage);
    if (!kStringIsEmpty(companyname)&&![NSString isEmpty:companyname]) {
        parameters[@"companyName"] = GetSaveString(companyname);
    }
   
    [HttpRequest getWithURLString:CompanyRanking parameters:parameters success:^(id responseObject) {
        NSArray *data = [RankingListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
        self.dataSource = [self.tableView pullWithPage:self.currPage data:data dataSource:self.dataSource];
        
//        if (self.currPage == 1) {
//            self.dataSource = [data mutableCopy];
//            [self endRefresh];
//        }else{
//            if (data.count) {
//                [self.dataSource addObjectsFromArray:data];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
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
