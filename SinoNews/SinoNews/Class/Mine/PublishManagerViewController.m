//
//  PublishManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishManagerViewController.h"
#import "NewsDetailViewController.h"

#import "PublishManagerCell.h"

@interface PublishManagerViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *articlesArr;   //评论数组
@property (nonatomic ,assign) NSInteger currPage;   //页码

@end

@implementation PublishManagerViewController
-(NSMutableArray *)_articlesArr
{
    if (!_articlesArr) {
        _articlesArr = [NSMutableArray new];
    }
    return _articlesArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noPublish" title:@"暂无发布的内容"];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.tableView registerClass:[PublishManagerCell class] forCellReuseIdentifier:PublishManagerCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        self.currPage = 1;
        [self requestUserPushNews];
        
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        if (!self.articlesArr.count) {
            self.currPage = 1;
        }else{
            self.currPage ++;
        }
        [self requestUserPushNews];
        
    }];
    
    [_tableView.mj_header beginRefreshing];
    
}

//显示删除提示
-(void)showDeleteViewWith:(NSInteger)index
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除此篇文章？" message:@"请确认" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestRemoveArticleWith:index];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articlesArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishManagerCell *cell = (PublishManagerCell *)[tableView dequeueReusableCellWithIdentifier:PublishManagerCellID];
    ArticleModel *model = self.articlesArr[indexPath.row];
    cell.model = model;
    @weakify(self)
    cell.moreClick = ^{
        @strongify(self)
        [self showDeleteViewWith:indexPath.row];
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
    ArticleModel *model = self.articlesArr[indexPath.row];
    if (model.itemType>=100&&model.itemType<200) {  //普通文章
        NewsDetailViewController *ndVC = [NewsDetailViewController new];
        ndVC.newsId = model.itemId;
        [self.navigationController pushViewController:ndVC animated:YES];
    }else if (model.itemType>=500&&model.itemType<600) { //问答
        CatechismViewController *cVC = [CatechismViewController new];
        cVC.news_id = model.itemId;
        [self.navigationController pushViewController:cVC animated:YES];
    }else{
        LRToast(@"未知文章");
    }
}

#pragma mark ----请求发送
//请求发布文章列表
-(void)requestUserPushNews
{
    [HttpRequest getWithURLString:GetCurrentUserNews parameters:@{@"page":@(self.currPage)} success:^(id responseObject) {
        NSArray *data = [ArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.articlesArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.articlesArr];
        
//        if (self.currPage == 1) {
//            self.articlesArr = [data mutableCopy];
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            [self.articlesArr addObjectsFromArray:data];
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

//删除一篇文章
-(void)requestRemoveArticleWith:(NSInteger)index
{
    ArticleModel *model = self.articlesArr[index];
    
    [HttpRequest postWithURLString:RemoveArticle parameters:@{@"newsId":@(model.itemId)} isShowToastd:NO isShowHud:YES isShowBlankPages:NO success:^(id response) {
        
        [self.articlesArr removeObject:model];
        [self.tableView reloadData];
        
    } failure:nil RefreshAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
