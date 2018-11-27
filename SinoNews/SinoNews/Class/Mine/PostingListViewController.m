//
//  PostingListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PostingListViewController.h"
#import "SeniorPostingViewController.h" //高级发帖

#import "ThePostListTableViewCell.h"
#import "PostDraftTableViewCell.h"

@interface PostingListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger currPage;
@end

@implementation PostingListViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = @"";
    NSString *notice = @"";
    if (self.type == 0) {
        title = @"我的帖子";
        notice = @"暂无帖子";
    }else
        if (self.type == 1) {
            title = @"我的草稿";
            notice = @"暂无草稿";
        }
    self.navigationItem.title = title;
    
    [self setUpTableView];
    
    [self processViewData];
}

//设置数据获取方案
-(void)processViewData
{
    if (_type == 0) {
        @weakify(self);
        _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
                return ;
            }
            self.currPage = 1;
            [self requestListPostForUser];
        }];
        _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            if (self.dataSource.count<=0) {
                self.currPage = 1;
            }else{
                self.currPage ++;
            }
            [self requestListPostForUser];
        }];
        [_tableView.mj_header beginRefreshing];
    }else if (_type == 1) {
        [self setDraftData];
    }
}

//读取本地草稿数据,设置界面
-(void)setDraftData
{
    self.dataSource = [SeniorPostDataModel getLocalDrafts];
    GGLog(@"本地草稿:%@",_dataSource);
    if (self.dataSource.count) {
        //倒序,让新添加或者修改的显示在最上面
        self.dataSource = (NSMutableArray *)[[self.dataSource reverseObjectEnumerator] allObjects];
    }
    [self.tableView reloadData];
}

-(void)setUpTableView
{
    if (_tableView) {
        return;
    }
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [_tableView addBakcgroundColorTheme];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [_tableView registerClass:[ThePostListTableViewCell class] forCellReuseIdentifier:ThePostListTableViewCellID];
    [_tableView registerClass:[PostDraftTableViewCell class] forCellReuseIdentifier:PostDraftTableViewCellID];
}

#pragma mark --- UITableViewDataSource ---
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
    if (self.type == 0) {
        ThePostListTableViewCell *cell0 = (ThePostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostListTableViewCellID];
        [cell0 setData:@{}];
        cell = cell0;
    }else if (self.type == 1){
        PostDraftTableViewCell *cell1 = (PostDraftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PostDraftTableViewCellID];
        SeniorPostDataModel *draftModel = self.dataSource[indexPath.row];
        cell1.draftModel = draftModel;
        cell = cell1;
    }
    [cell addBakcgroundColorTheme];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    @weakify(self);
    if (self.type==1) {
        SeniorPostDataModel *draftModel = self.dataSource[indexPath.row];
        if (draftModel.postType == 3) {
            SeniorPostingViewController *spVC = [SeniorPostingViewController new];
            
            spVC.refreshCallBack = ^{
                @strongify(self);
                [self setDraftData];
            };
            spVC.postModel = draftModel;
            [self presentViewController:[[RTRootNavigationController alloc]initWithRootViewController:spVC] animated:YES completion:nil];
        }
    }
}

#pragma mark --请求
-(void)requestListPostForUser
{
    [HttpRequest postWithURLString:ListPostForUser parameters:@{@"currPage":@(self.currPage)} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        
    } failure:^(NSError *error) {
        
    } RefreshAction:nil];
}

@end
