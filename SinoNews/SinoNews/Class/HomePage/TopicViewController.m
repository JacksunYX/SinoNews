//
//  TopicViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "TopicViewController.h"
#import "NewsDetailViewController.h"
#import "TopicModel.h"

#import "HomePageFirstKindCell.h"
#import "HomePageFourthCell.h"

#define NAVBAR_CHANGE_POINT 50

@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) TopicModel *model;
@property (nonatomic,strong) UIView *headView;
@end

@implementation TopicViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTopLine];
    [self addTableView];
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = GetSaveString(self.model.itemTitle);
    //使用这句话设置导航栏颜色
//    [self.navigationController.navigationBar setBarTintColor:RedColor];
    
    [self showOrHideLoadView:YES page:2];
    
    [self requestShowTopicDetail];
}

-(void)setNavigationBarBackImageColor:(UIColor *)color
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    self.tableView.delegate = self;
//    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    self.tableView.delegate = nil;
//    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [_tableView addBakcgroundColorTheme];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    
//    @weakify(self)
//    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
//        @strongify(self)
////        if (self.tableView.mj_footer.isRefreshing) {
////            [self.tableView.mj_header endRefreshing];
////        }
//        [self requestShowTopicDetail];
//    }];
    
//    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self)
//        if (self.tableView.mj_header.isRefreshing) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//
//    }];
    
//    [_tableView.mj_header beginRefreshing];
}

-(void)addHeadView
{
    if (!self.headView) {
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 270)];
        [self.headView addBakcgroundColorTheme];
        
        UIImageView *titltImg = [UIImageView new];
//        titltImg.backgroundColor = Arc4randomColor;
        
        UILabel *title = [UILabel new];
        title.font = FontScale(20);
        [title addTitleColorTheme];
        title.numberOfLines = 1;
        
        UILabel *subTitle = [UILabel new];
        subTitle.font = PFFontL(15);
        subTitle.textColor = HexColor(#868e97);
//        subTitle.lee_theme.LeeCustomConfig(@"contentColor", ^(id item, id value) {
//            if (UserGetBool(@"NightMode")) {
//                [(UILabel *)item setTextColor:value];
//            }else{
//                [(UILabel *)item setTextColor:HexColor(#868e97)];
//            }
//        });
        
        [self.headView sd_addSubviews:@[
                                        titltImg,
                                        title,
                                        subTitle,
                                        
                                        ]];
        
        titltImg.sd_layout
        .topEqualToView(self.headView)
        .leftEqualToView(self.headView)
        .rightEqualToView(self.headView)
        .heightIs(125)
        ;
        [titltImg sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.bigImage))];
        
        title.sd_layout
        .topSpaceToView(titltImg, 25)
        .leftSpaceToView(self.headView, 10)
        .rightSpaceToView(self.headView, 10)
        .heightIs(22)
        ;
        title.text = GetSaveString(self.model.itemTitle);
        
        subTitle.sd_layout
        .topSpaceToView(title, 10)
        .leftSpaceToView(self.headView, 10)
        .rightSpaceToView(self.headView, 10)
        .autoHeightRatio(0)
        ;
        [subTitle setMaxNumberOfLinesToShow:3];
        subTitle.text = GetSaveString(self.model.descript);
    }
    
    self.tableView.tableHeaderView = self.headView;
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
//    HomePageFirstKindCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
//
//    HomePageModel *model = self.dataSource[indexPath.row];
//    cell.model = model;
    UITableViewCell *cell;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = (HomePageModel *)model;
        //暂时只分2种
        if (model1.itemType == 100) {//无图
            HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
            cell1.model = model1;
            cell = (UITableViewCell *)cell1;
        }else{//1图
            HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
            cell1.model = model1;
            cell = (UITableViewCell *)cell1;
        }
    }
    
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
    HomePageModel * model = self.dataSource[indexPath.row];
    
    NewsDetailViewController *ndVC = [NewsDetailViewController new];
    ndVC.newsId = [(HomePageModel *)model itemId];
    [self.navigationController pushViewController:ndVC animated:YES];
}

#pragma mark ----- UIScrollViewDelegat
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = WhiteColor;
    if (UserGetBool(@"NightMode")) {
        color = HexColor(#1c2023);
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark ----- 请求发送
//展示专题详情
-(void)requestShowTopicDetail
{
    [HttpRequest getWithURLString:ShowTopicDetails parameters:@{@"topicId":@(self.topicId)} success:^(id responseObject) {
        self.model = [TopicModel mj_objectWithKeyValues:responseObject[@"data"]];
        //因为专题里的新闻后台返回的数据itemType也是200开头的,但是实际上它们在这里只是普通新闻，所以这里全部手动变为普通新闻的itemType
//        for (HomePageModel *model in self.model.topicNewsList) {
//            if (model.itemType == 200) {
//                model.itemType = 100;
//            }else if (model.itemType == 201) {
//                model.itemType = 101;
//            }else if (model.itemType == 202) {
//                model.itemType = 102;
//            }
//            model.tipName = @"";
//        }
        self.dataSource = [self.model.topicNewsList mutableCopy];
        [self addHeadView];
        [self showOrHideLoadView:NO page:2];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}






@end
