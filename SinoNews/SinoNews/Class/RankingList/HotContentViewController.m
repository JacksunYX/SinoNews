//
//  HotContentViewController.m
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/6/26.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "HotContentViewController.h"
#import "HotContentTableViewCell.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"
#import "HomePageFourthCell.h"

#import "ReadPostListTableViewCell.h"

@interface HotContentViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) LXSegmentBtnView *segmentView;

@property (nonatomic, strong) BaseTableView *tableLeft;
@property (nonatomic, strong) BaseTableView *tableCenter;
@property (nonatomic, strong) BaseTableView *tableRight;

@property (nonatomic, strong) NSMutableArray *centerDataSource;
@property (nonatomic, strong) NSMutableArray *leftDataSource;
@property (nonatomic, strong) NSMutableArray *rightDataSource;

@end

@implementation HotContentViewController

-(LXSegmentBtnView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [LXSegmentBtnView new];
        [self.view addSubview:_segmentView];
        
        _segmentView.btnTitleNormalColor = HexColor(#1282EE);
        _segmentView.btnTitleSelectColor = WhiteColor;
        _segmentView.btnBackgroundNormalColor = WhiteColor;
        _segmentView.btnBackgroundSelectColor = HexColor(#1282EE);
        _segmentView.bordColor = HexColor(#1282EE);
        
        _segmentView.sd_layout
        .topSpaceToView(self.view, 10)
        .centerXEqualToView(self.view)
        .widthIs(330)
        .heightIs(30)
        ;
        [_segmentView updateLayout];
        _segmentView.btnTitleArray = [NSArray arrayWithObjects:@"热门帖子",@"热门新闻",@"热门点赞",nil];
        @weakify(self);
        _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
            @strongify(self);
            [self reloadTableWithIndex:index];
        };
    }
    return _segmentView;
}

-(NSMutableArray *)centerDataSource
{
    if (!_centerDataSource) {
        _centerDataSource = [NSMutableArray new];
    }
    return _centerDataSource;
}

-(NSMutableArray *)leftDataSource
{
    if (!_leftDataSource) {
        _leftDataSource = [NSMutableArray new];
    }
    return _leftDataSource;
}

-(NSMutableArray *)rightDataSource
{
    if (!_rightDataSource) {
        _rightDataSource = [NSMutableArray new];
    }
    return _rightDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//添加视图
-(void)addViews
{
    self.segmentView.titleFont = PFFontM(14);
    
    [self createTableLeft];
    
    [self createCenterTable];
    
    [self createTableRight];
    
    [self reloadTableWithIndex:0];
}

-(void)createTableLeft
{
    self.tableLeft = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableLeft addBakcgroundColorTheme];
    self.tableLeft.delegate = self;
    self.tableLeft.dataSource = self;
    self.tableLeft.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableLeft.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableLeft.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableLeft];
    self.tableLeft.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    
    [self.tableLeft registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    [_tableLeft registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
    
    @weakify(self);
    self.tableLeft.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotPost];
    }];
}

-(void)createCenterTable
{
    self.tableCenter = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableCenter addBakcgroundColorTheme];
    self.tableCenter.delegate = self;
    self.tableCenter.dataSource = self;
    self.tableCenter.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableCenter.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableCenter.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableCenter];
    self.tableCenter.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    //注册
    [_tableCenter registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableCenter registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
    [_tableCenter registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
    [_tableCenter registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    [self.tableCenter registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    @weakify(self);
    self.tableCenter.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotNews];
    }];
}

-(void)createTableRight
{
    self.tableRight = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableRight addBakcgroundColorTheme];
    self.tableRight.delegate = self;
    self.tableRight.dataSource = self;
    self.tableRight.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableRight.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableRight.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.view addSubview:self.tableRight];
    self.tableRight.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    //注册
    [self.tableRight registerClass:[HotContentTableViewCell class] forCellReuseIdentifier:HotContentTableViewCellID];
    
    [_tableRight registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
    
    @weakify(self);
    self.tableRight.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestHotPraise];
    }];
}

//根据不同情况显隐试图
-(void)reloadTableWithIndex:(NSInteger)index
{
    if (index==1) {
        [self.tableLeft setHidden:YES];
        [self.tableCenter setHidden:NO];
        [self.tableRight setHidden:YES];
        [self.tableCenter reloadData];
        if (self.centerDataSource.count<=0) {
            [self.tableCenter.mj_header beginRefreshing];
        }
    }else if (index==2) {
        [self.tableLeft setHidden:YES];
        [self.tableCenter setHidden:YES];
        [self.tableRight setHidden:NO];
        [self.tableRight reloadData];
        if (self.rightDataSource.count<=0) {
            [self.tableRight.mj_header beginRefreshing];
        }
    }else{
        [self.tableLeft setHidden:NO];
        [self.tableCenter setHidden:YES];
        [self.tableRight setHidden:YES];
        [self.tableLeft reloadData];
        if (self.leftDataSource.count<=0) {
            [self.tableLeft.mj_header beginRefreshing];
        }
    }
}

#pragma mark ---- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableLeft) {
        return self.leftDataSource.count;
    }
    if (tableView == self.tableCenter) {
        return self.centerDataSource.count;
    }
    return self.rightDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSMutableDictionary *dataModel = NSMutableDictionary.new;
    //    dataModel[@"type"] = @(0);
    UITableViewCell *cell;
    if (tableView == _tableLeft) {
        //        SeniorPostDataModel *model = self.leftDataSource[indexPath.row];
        //        dataModel[@"title"] = model.postTitle;
        //        dataModel[@"pushTime"] = model.createTime;
        //        dataModel[@"viewCount"] = @(model.viewCount);
        //        dataModel[@"num"] = @(indexPath.row+1);
        ReadPostListTableViewCell *cell = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        SeniorPostDataModel *model = self.leftDataSource[indexPath.row];
        cell.model = model;
        
    }else if (tableView == _tableCenter){
        //        id model = self.centerDataSource[indexPath.row];
        //        if ([model isKindOfClass:[HomePageModel class]]) {
        //            HomePageModel *model1 = model;
        //            dataModel[@"title"] = model1.itemTitle;
        //            dataModel[@"pushTime"] = model1.createTime;
        //            dataModel[@"viewCount"] = @(model1.viewCount);
        //            dataModel[@"num"] = @(indexPath.row+1);
        //        }
        id model = self.centerDataSource[indexPath.row];
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = (HomePageModel *)model;
            switch (model1.itemType) {
                case 400:
                case 500:
                case 100:   //无图
                {
                    HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                    
                case 401:
                case 501:
                case 101:   //1图
                {
                    HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                case 403:
                case 503:
                case 103:   //3图
                {
                    HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                    cell1.model = model1;
                    cell = (UITableViewCell *)cell1;
                }
                    break;
                    
                default:
                    break;
            }
        }
        return cell;
    }else{
        //        SeniorPostDataModel *model = self.rightDataSource[indexPath.row];
        //        dataModel[@"type"] = @(1);
        //        dataModel[@"title"] = model.postTitle;
        //        dataModel[@"pushTime"] = model.createTime;
        //        dataModel[@"viewCount"] = @(model.praiseCount);
        //        dataModel[@"num"] = @(indexPath.row+1);
        
        ReadPostListTableViewCell *cell = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        SeniorPostDataModel *model = self.rightDataSource[indexPath.row];
        cell.model = model;
    }
    //    HotContentTableViewCell *cell = (HotContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HotContentTableViewCellID];
    //    cell.model = dataModel;
    [cell addBakcgroundColorTheme];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW-20 tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableCenter){
        id model = self.centerDataSource[indexPath.row];
        UIViewController *pushVC;
        NSInteger itemId = 0;
        if ([model isKindOfClass:[HomePageModel class]]) {
            HomePageModel *model1 = model;
            itemId = model1.itemId;
            if (model1.itemType>=400&&model1.itemType<500) { //投票
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = model1.itemId;
                ndVC.isVote = YES;
                pushVC = ndVC;
            }else
                if (model1.itemType>=500&&model1.itemType<600) { //问答
                    CatechismViewController *cVC = [CatechismViewController new];
                    cVC.news_id = model1.itemId;
                    pushVC = cVC;
                }else{
                    NewsDetailViewController *ndVC = [NewsDetailViewController new];
                    ndVC.newsId = model1.itemId;
                    pushVC = ndVC;
                }
            
        }else if ([model isKindOfClass:[TopicModel class]]){
            TopicModel *model2 = model;
            TopicViewController *tVC = [TopicViewController new];
            //只有专题是用的topicId
            tVC.topicId = [model2.topicId integerValue];
            itemId = [model2.topicId integerValue];
            pushVC = tVC;
        }
        [self.navigationController pushViewController:pushVC animated:YES];
    }else{
        SeniorPostDataModel *model;
        if (tableView == _tableLeft) {
            model = self.leftDataSource[indexPath.row];
        }else{
            model = self.rightDataSource[indexPath.row];
        }
        UIViewController *vc;
        if (model.postType == 2) { //投票
            TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
            tvpdVC.postModel.postId = model.postId;
            vc = tvpdVC;
        }else{
            ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
            tpdVC.postModel.postId = model.postId;
            vc = tpdVC;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ----- 请求发送
//请求热门帖子
-(void)requestHotPost
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotPost parameters:parameters success:^(id responseObject) {
        NSArray *data = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableLeft.mj_header endRefreshing];
        self.leftDataSource = [data mutableCopy];
        
        [self.tableLeft reloadData];
    } failure:^(NSError *error) {
        [self.tableLeft.mj_header endRefreshing];
    }];
}

//请求热门新闻
-(void)requestHotNews
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotNews parameters:parameters success:^(id responseObject) {
        NSMutableArray *dataArr = [UniversalMethod getProcessNewsData:responseObject[@"data"]];
        [self.tableCenter.mj_header endRefreshing];
        self.centerDataSource = [dataArr mutableCopy];
        
        [self.tableCenter reloadData];
    } failure:^(NSError *error) {
        [self.tableCenter.mj_header endRefreshing];
    }];
}

//请求热门点赞
-(void)requestHotPraise
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest getWithURLString:HotContent_hotPraise parameters:parameters success:^(id responseObject) {
        NSArray *data = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableRight.mj_header endRefreshing];
        self.rightDataSource = [data mutableCopy];
        
        [self.tableRight reloadData];
    } failure:^(NSError *error) {
        [self.tableRight.mj_header endRefreshing];
    }];
}

@end
