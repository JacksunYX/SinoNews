//
//  UserAttentionOrFansVC.m
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UserAttentionOrFansVC.h"
#import "UserInfoViewController.h"
#import "MyFansTableViewCell.h"

@interface UserAttentionOrFansVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currPage;   //页码(起始为1)
@end

@implementation UserAttentionOrFansVC
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 0) {
        self.navigationItem.title = @"TA的关注";
    }else if(self.type == 1) {
        self.navigationItem.title = @"他的粉丝";
    }else if(self.type == 2) {
        self.navigationItem.title = @"搜索作者";
    }
    
    [self addTableview];
    
    if (self.type == 2) {
        self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"" title:@"没有搜索到相关结果"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableview
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];

    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        BaseTableView *table = item;
        table.backgroundColor = value;
        if (UserGetBool(@"NightMode")) {
            table.separatorColor = CutLineColorNight;
        }else{
            table.separatorColor = CutLineColor;
        }
    });
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    
    //注册
    [self.tableView registerClass:[MyFansTableViewCell class] forCellReuseIdentifier:MyFansTableViewCellID];
    
    if (self.type == 2) {
        //发送搜索请求
        [self requestWithKeyword];
        return;
    }
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.currPage = 1;
        if (self.type == 0) {
            [self requestShowUser];
        }else{
            [self requestShowFollowUser];
        }
        
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (!self.dataSource.count) {
            self.currPage = 1;
        }else{
            self.currPage++;
        }
        if (self.type == 0) {
            [self requestShowUser];
        }else{
            [self requestShowFollowUser];
        }
    }];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFansTableViewCell *cell = (MyFansTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyFansTableViewCellID];
    cell.type = 1;
    MyFansModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    @weakify(self)
    cell.attentionBlock = ^{
        @strongify(self)
        [self requestIsAttentionWithFansModel:model];
    };
    [cell addBakcgroundColorTheme];
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
    UserInfoViewController *uiVC = [UserInfoViewController new];
    MyFansModel *model = self.dataSource[indexPath.row];
    uiVC.userId = model.userId;
    @weakify(self)
    uiVC.refreshBlock = ^{
        //刷新界面
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:uiVC animated:YES];
}


#pragma mark ---- 请求发送
//关注/取消关注
-(void)requestIsAttentionWithFansModel:(MyFansModel *)model
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(model.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        model.isFollow = !model.isFollow;
//        UserModel *user = [UserModel getLocalUserModel];
        
        if (model.isFollow) {
            LRToast(@"关注成功");
//            user.followCount ++;
        }else{
            LRToast(@"取消关注");
//            user.followCount --;
        }
//        [UserModel coverUserData:user];
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self.tableView.mj_header beginRefreshing];
    }];
}

//查询关注列表
-(void)requestShowUser
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"currPage"] = @(self.currPage);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest postWithURLString:ShowUser parameters:parameters isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSArray *arr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        
        self.dataSource = [self.tableView pullWithPage:self.currPage data:arr dataSource:self.dataSource];
        
//        if (self.currPage == 1) {
//            [self.tableView.mj_header endRefreshing];
//            if (arr.count) {
//                self.dataSource = [arr mutableCopy];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }else{
//            if (arr.count) {
//                [self.dataSource addObjectsFromArray:arr];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } RefreshAction:nil];
}

//查询粉丝列表
-(void)requestShowFollowUser
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"currPage"] = @(self.currPage);
    parameters[@"userId"] = @(self.userId);
    [HttpRequest postWithURLString:ShowFollowUser parameters:parameters isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSArray *arr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        
        self.dataSource = [self.tableView pullWithPage:self.currPage data:arr dataSource:self.dataSource];
        
//        if (self.currPage == 1) {
//            [self.tableView.mj_header endRefreshing];
//            if (arr.count) {
//                self.dataSource = [arr mutableCopy];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }else{
//            if (arr.count) {
//                [self.dataSource addObjectsFromArray:arr];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } RefreshAction:nil];
}

//查询作者列表
-(void)requestWithKeyword
{
    [self.tableView ly_startLoading];
    [HttpRequest postWithURLString:ListUserForSearch parameters:@{@"keyword":GetSaveString(self.keyword)} isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id response) {
        self.dataSource = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView endAllRefresh];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView ly_endLoading];
    } RefreshAction:nil];
    
}

@end
