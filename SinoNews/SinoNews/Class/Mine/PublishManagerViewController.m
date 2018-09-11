//
//  PublishManagerViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishManagerViewController.h"
#import "NewsDetailViewController.h"
#import "DraftDetailViewController.h"

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
    NSString *notice = @"暂无发布内容";
    if (self.type == 1) {
        notice = @"暂无待审核内容";
    }else if (self.type == 2){
        notice = @"暂无草稿";
    }
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noPublish" title:notice];
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
    self.tableView.separatorColor = CutLineColor;
    [self.tableView registerClass:[PublishManagerCell class] forCellReuseIdentifier:PublishManagerCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_header endRefreshing];
//            return ;
//        }
        [self.tableView ly_startLoading];
//        self.currPage = 1;
        
        [self loadWhichRequest];
        
    }];
    
    /*
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
        [self loadWhichRequest];
        
    }];
     */
    
    [_tableView.mj_header beginRefreshing];
    
}

//加载指定的type请求
-(void)loadWhichRequest
{
    switch (self.type) {
        case 0: //已审核
            [self requestUserPushNews];
            break;
        case 1: //待审核
            [self requestWaitConfirm];
            break;
        case 2: //草稿箱
            [self requestDrafts];
            break;
        default:
            break;
    }
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
//    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishManagerCell *cell = (PublishManagerCell *)[tableView dequeueReusableCellWithIdentifier:PublishManagerCellID];
    cell.type = self.type;
    NewPublishModel *model = self.articlesArr[indexPath.row];
    cell.newsModel = model;
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
    NewPublishModel *model = self.articlesArr[indexPath.row];
    if (self.type==0) {
//        ArticleModel *model = self.articlesArr[indexPath.row];
//        if (model.itemType>=100&&model.itemType<200) {  //普通文章
//            NewsDetailViewController *ndVC = [NewsDetailViewController new];
//            ndVC.newsId = model.itemId;
//            [self.navigationController pushViewController:ndVC animated:YES];
//        }else if (model.itemType>=500&&model.itemType<600) { //问答
//            CatechismViewController *cVC = [CatechismViewController new];
//            cVC.news_id = model.itemId;
//            [self.navigationController pushViewController:cVC animated:YES];
//        }else{
//            LRToast(@"未知文章");
//        }
        UIViewController *pushVC;
        if (model.newsType <= 1) {   //新闻
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = model.newsId;
            pushVC = ndVC;
        }else if (model.newsType == 2){  //问答
            CatechismViewController *cVC = [CatechismViewController new];
            cVC.news_id = model.newsId;
            pushVC = cVC;
        }else if (model.newsType == 3){  //投票
            VoteViewController *vVC = [VoteViewController new];
            vVC.newsId = model.newsId;
            pushVC = vVC;
        }else if (model.newsType == 4){  //悬赏问答
            
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else if (self.type==1||self.type==2){
        //跳转到草稿展示
        DraftDetailViewController *ddVC = [DraftDetailViewController new];
        ddVC.newsId = model.newsId;
        ddVC.type = model.newsType;
        if (self.type == 1) {
            ddVC.isToAudit = YES;
        }
        ddVC.refreshBlock = ^{
            [self.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:ddVC animated:YES];
    }
    
}

#pragma mark ----请求发送
//请求已审核文章
-(void)requestUserPushNews
{
    [HttpRequest getWithURLString:ListCheckedNewsForUser parameters:nil success:^(id responseObject) {
//        NSArray *data = [ArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//        self.articlesArr = [self.tableView pullWithPage:self.currPage data:data dataSource:self.articlesArr];
        
        NSArray *data = [NewPublishModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.articlesArr = [data mutableCopy];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}

//请求待审核文章
-(void)requestWaitConfirm
{
    [HttpRequest getWithURLString:ListNewsToReviewForUser parameters:nil success:^(id responseObject) {
        NSArray *data = [NewPublishModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.articlesArr = [data mutableCopy];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}

//请求草稿箱文章
-(void)requestDrafts
{
    [HttpRequest getWithURLString:ListNewsDraftForUser parameters:nil success:^(id responseObject) {
        NSArray *data = [NewPublishModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.articlesArr = [data mutableCopy];
        
        [self.tableView.mj_header endRefreshing];
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
