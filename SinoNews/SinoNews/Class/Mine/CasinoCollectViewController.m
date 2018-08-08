//
//  CasinoCollectViewController.m
//  SinoNews
//
//  Created by Michael on 2018/8/8.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CasinoCollectViewController.h"
#import "RankDetailViewController.h"
#import "MyCollectCasinoCell.h"
#import "RankingListModel.h"

@interface CasinoCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,assign) NSInteger currPage;    //页码
//娱乐城数据源数组
@property (nonatomic,strong) NSMutableArray *casinoArray;

//存储选择要删除数据数组
@property (nonatomic,strong) NSMutableArray *deleteArray;

@end

@implementation CasinoCollectViewController
- (NSMutableArray *)casinoArray
{
    if (!_casinoArray) {
        _casinoArray = [NSMutableArray array];
    }
    return _casinoArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收藏的娱乐城";
    
    [self showTopLine];
    [self addNavigationBtn];
    [self addTableViews];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noCollect" title:@"暂无任何收藏"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addNavigationBtn
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *rightImg = @"attention_search";
        
        if (UserGetBool(@"NightMode")) {
            rightImg = [rightImg stringByAppendingString:@"_night"];
            
        }
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(searchAction) image:rightImg hightimage:nil andTitle:@""];
    });
}

-(void)addTableViews
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //允许支持同时多选多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //注册
    [self.tableView registerClass:[MyCollectCasinoCell class] forCellReuseIdentifier:MyCollectCasinoCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing||self.tableView.editing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.currPage = 1;

        [self requestCompanyList];
        
    }];
    
//    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//        if (self.tableView.mj_header.isRefreshing||self.tableView.editing) {
//            [self.tableView.mj_footer endRefreshing];
//            return ;
//        }
//        if (!self.casinoArray.count) {
//            self.currPage = 1;
//        }else{
//            self.currPage++;
//        }
//
//        [self requestCompanyList];
//
//    }];
    
}

//重置当前显示状态
-(void)resetStatus
{
    //将数据源数组中包含有删除数组中的数据删除掉
    [self.casinoArray removeObjectsInArray:self.deleteArray];
    //清空删除数组
    [self.deleteArray removeAllObjects];
    
    [self.tableView reloadData];
}

-(void)searchAction
{
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入要搜索的娱乐城" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //回调搜索
        [searchViewController dismissViewControllerAnimated:NO completion:nil];
        [self requestCasinoDataWithKeyName:searchText];
    }];
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.casinoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectCasinoCell *cell = (MyCollectCasinoCell *)[tableView dequeueReusableCellWithIdentifier:MyCollectCasinoCellID];
    cell.model = self.casinoArray[indexPath.row];
    
    cell.webPushBlock = ^{
        GGLog(@"跳转到官网");
    };
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    //跳转到公司详情
    RankDetailViewController *rdVC = [RankDetailViewController new];
    CompanyDetailModel *model = self.casinoArray[indexPath.row];
    rdVC.companyId = model.companyId;
    [self.navigationController pushViewController:rdVC animated:YES];
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加取消收藏按钮
    UITableViewRowAction *cancelCollectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.deleteArray addObject:[self.casinoArray objectAtIndex:indexPath.row]];
        [self requestCancelCompanysCollects];
    }];
    cancelCollectAction.backgroundColor = HexColor(#51AAFF);
    
    return @[cancelCollectAction];
}

#pragma mark ---- 请求发送
//收藏的游戏公司列表
-(void)requestCompanyList
{
    [self.tableView ly_startLoading];
    @weakify(self)
    [HttpRequest getWithURLString:ListConcernedCompanyForUser parameters:nil success:^(id responseObject) {
        @strongify(self)
        self.casinoArray = [CompanyDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:nil];
}

//批量取消关注游戏公司
-(void)requestCancelCompanysCollects
{
    NSMutableArray *array = [NSMutableArray new];
    for (CompanyDetailModel *model in self.deleteArray) {
        [array addObject:model.companyId];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    @weakify(self)
    [HttpRequest postWithURLString:CancelCompanysCollects parameters:@{@"companyIds":jsonString} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        @strongify(self)
        [self resetStatus];
    } failure:nil RefreshAction:^{
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

//根据关键字查询娱乐城
-(void)requestCasinoDataWithKeyName:(NSString *)keyname
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    if (!kStringIsEmpty(keyname)) {
        parameters[@"companyName"] = GetSaveString(keyname);
    }
    
    [HttpRequest getWithURLString:CompanyRanking parameters:parameters success:^(id responseObject) {
        NSArray *data = [RankingListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        
//        self.casinoArray = [self.tableView pullWithPage:self.currPage data:data dataSource:self.casinoArray];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self endRefresh];
    }];
    
}


@end
