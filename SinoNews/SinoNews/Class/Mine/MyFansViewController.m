//
//  MyFansViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyFansViewController.h"
#import "UserInfoViewController.h"
#import "MyFansTableViewCell.h"

@interface MyFansViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currPage;   //页码(起始为1)
@end

@implementation MyFansViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"粉丝";
    
    [self addTableview];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noFans" title:@"暂无粉丝关注你"];
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
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = RGBA(227, 227, 227, 1);
    
    //注册
    [self.tableView registerClass:[MyFansTableViewCell class] forCellReuseIdentifier:MyFansTableViewCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        self.currPage = 1;
        [self requestFansList];
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
        [self requestFansList];
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
//我的粉丝列表
-(void)requestFansList
{
    [HttpRequest postWithURLString:Fans_myFollow parameters:@{@"currPage":@(self.currPage)} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
        NSArray *arr = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"][@"data"]];
        
        if (self.currPage == 1) {
            [self.tableView.mj_header endRefreshing];
            if (arr.count) {
                self.dataSource = [arr mutableCopy];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            if (arr.count) {
                [self.dataSource addObjectsFromArray:arr];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }

        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } RefreshAction:nil];
}

//关注/取消关注
-(void)requestIsAttentionWithFansModel:(MyFansModel *)model
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"userId"] = @(model.userId);
    [HttpRequest postWithTokenURLString:AttentionUser parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id res) {
        model.isFollow = !model.isFollow;
        if (model.isFollow) {
            LRToast(@"关注成功～");
        }else{
            LRToast(@"已取消关注");
        }
        [self.tableView reloadData];
    } failure:nil RefreshAction:^{
        [self.tableView.mj_header beginRefreshing];
    }];
}




@end
