//
//  CommentManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CommentManagerViewController.h"
#import "NewsDetailViewController.h"
#import "UserInfoCommentCell.h"

@interface CommentManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *commentsArr;   //评论数组
@property (nonatomic ,assign) NSInteger currPage;   //页码
@end

@implementation CommentManagerViewController
-(NSMutableArray *)commentsArr
{
    if (!_commentsArr) {
        _commentsArr = [NSMutableArray new];
    }
    return _commentsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = @"";
    NSString *notice = @"";
    if (self.type == 0) {
        title = @"我的评论";
        notice = @"暂无评论";
    }else
    if (self.type == 1) {
        title = @"我的回复";
        notice = @"暂无回复";
    }
    self.navigationItem.title = title;
    [self addTableView];
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noComment" title:notice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加上方的tableview
-(void)addTableView
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
    [self.tableView registerClass:[UserInfoCommentCell class] forCellReuseIdentifier:UserInfoCommentCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        self.currPage = 1;
        [self requestUserComments];
        
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (!self.commentsArr.count) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestUserComments];
        
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
    return self.commentsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCommentCell *cell = (UserInfoCommentCell *)[tableView dequeueReusableCellWithIdentifier:UserInfoCommentCellID];
    CompanyCommentModel *model = self.commentsArr[indexPath.row];
    cell.model = model;
    
    @weakify(self)
    cell.clickNewBlock = ^{
        @strongify(self)
        if (model.newsType == 0) {
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = [model.newsId integerValue];
            [self.navigationController pushViewController:ndVC animated:YES];
        }
        
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
    
}

#pragma mark ---- 请求发送
//获取用户评论
-(void)requestUserComments
{
    [HttpRequest getWithURLString:GetCurrentUserComments parameters:@{@"page":@(self.currPage)} success:^(id responseObject) {
        NSArray *data = [CompanyCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        self.commentsArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.commentsArr];
        
//        if (self.currPage == 1) {
//            self.commentsArr = [data mutableCopy];
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            [self.commentsArr addObjectsFromArray:data];
//            if (data.count) {
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}




@end
