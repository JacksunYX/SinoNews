//
//  RankViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankViewController.h"
#import "RankListViewController.h"
#import "SearchViewController.h"

#import "ADModel.h"

#import "HeadBannerView.h"
#import "LineCollectionViewCell.h"
#import "LineLayout.h"
#import "MoveCell.h"
#import "MyCollectCasinoCell.h"


@interface RankViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate,MLMSegmentHeadDelegate,PYSearchViewControllerDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@property (nonatomic,strong) NSMutableArray *adArr; //轮播广告数组
//中间的排行视图
@property (nonatomic, strong) UICollectionView *lineCollectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *leftDataSource;
@property (nonatomic, strong) NSMutableArray *rightDataSource;
//替换成新的视图展示
@property (nonatomic, strong) BaseTableView *tableLeft;
@property (nonatomic, strong) BaseTableView *tableV;
@property (nonatomic, strong) BaseTableView *tableRight;
@property (nonatomic, strong) UIView *rightTableHead;

//保存需要取消收藏的娱乐场的数组
@property (nonatomic ,strong) NSMutableArray *deleteArray;

//下方广告视图
@property (nonatomic ,strong) UICollectionView *adCollectionView;
@property (nonatomic ,strong) NSMutableArray *adDatasource;

@property (nonatomic,strong) UIView *naviTitle;

@property (nonatomic,strong) LXSegmentBtnView *segmentView;

@end

@implementation RankViewController
-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
    }
    return _adDatasource;
}

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
        _segmentView.btnTitleArray = [NSArray arrayWithObjects:@"综合排行",@"单项排行",@"娱乐场收藏",nil];
        @weakify(self);
        _segmentView.lxSegmentBtnSelectIndexBlock = ^(NSInteger index, UIButton *btn) {
            @strongify(self);
            [self reloadTableWithIndex:index];
        };
    }
    return _segmentView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        //        NSArray *title = @[
        //                           @"综合排行",
        //                           @"体育投注排行",
        //                           @"真人游戏排行",
        //                           @"男性玩家排行",
        //                           @"女性玩家排行",
        //                           @"未成年玩家排行",
        //                           ];
        //        NSArray *backImg = @[
        //                                @"rank_banner0",
        //                                @"rank_banner1",
        //                                @"rank_banner2",
        //                                @"rank_banner3",
        //                                @"rank_banner0",
        //                                @"rank_banner1",
        //                                ];
        //
        //        NSArray *updateTime = @[
        //                                   @"2018年5月30日",
        //                                   @"2018年5月31日",
        //                                   @"2018年5月15日",
        //                                   @"2018年6月1日",
        //                                   @"2018年4月23日",
        //                                   @"2018年1月1日",
        //                                   ];
        _dataSource = [NSMutableArray new];
        //
        //        for (int i = 0; i < title.count; i ++) {
        //            NSMutableDictionary *dic = [NSMutableDictionary new];
        //            dic[@"title"] = title[i];
        //            dic[@"backImg"] = backImg[i];
        //            dic[@"updateTime"] = updateTime[i];
        //            [_datasource addObject:dic];
        //        }
        
    }
    return _dataSource;
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

-(NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray new];
    }
    return _deleteArray;
}

-(UIView *)rightTableHead
{
    if (!_rightTableHead) {
        _rightTableHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW - 20, 0)];
        _rightTableHead.backgroundColor = WhiteColor;
        UILabel *notice = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW - 20 - 20, 0)];
        notice.numberOfLines = 0;
        [_rightTableHead addSubview:notice];
        notice.font = PFFontL(14);
        notice.textColor = HexColor(#ABB2C3);
        notice.textAlignment = NSTextAlignmentCenter;
        notice.text = @"以下为推荐收藏娱乐场，可点击右上角搜索您想关注的娱乐场";
        [notice sizeToFit];
        notice.frame = CGRectMake((ScreenW - 20)/2 - notice.frame.size.width/2, 10, notice.frame.size.width, notice.frame.size.height);
    
        _rightTableHead.frame = CGRectMake(0, 0, ScreenW - 20, 20 + notice.frame.size.height);
    }
    return _rightTableHead;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addNavigationView];
//    [self setNaviTitle];
    
    [self addViews];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.adArr.count<=0) {
//        [self requestTopBanner];
//    }
//    if (self.adDatasource.count<=0) {
//        [self requestBottomBanner];
//    }
    if (self.dataSource.count<=0&&_segmentView.selectedIndex==1) {
        [self requestRanking];
    }
    if (self.leftDataSource.count<=0&&_segmentView.selectedIndex==0) {
        [self.tableLeft.mj_header beginRefreshing];
    }
    if (self.rightDataSource.count<=0&&_segmentView.selectedIndex==2) {
        [self.tableRight.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 44) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.2;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 2;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    _segHead.deSelectColor = HexColor(#1a1a1a);
    _segHead.maxTitles = 2;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - BOTTOM_MARGIN) vcOrViews:[self vcArr:titles.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
    });
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    BaseViewController *vc1 = [BaseViewController new];
    BaseViewController *vc2 = [BaseViewController new];
    [arr addObjectsFromArray:@[
                               vc1,
                               vc2,
                               ]];
    return arr;
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(@"attention_search")];
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
    sVC.selectIndex = 1;
    [self.navigationController pushViewController:sVC animated:NO];
}

//添加视图
-(void)addViews
{
//    [self addTopLoopView];
//    [self addBottomADView];
    //    [self addCenterRankView];
    self.segmentView.titleFont = PFFontM(14);
//    self.segmentView.selectedIndex = 1;
    
    [self createTableLeft];
    
    [self createTable];
    
    [self createTableRight];
}

//根据不同情况显隐试图
-(void)reloadTableWithIndex:(NSInteger)index
{
    if (index==1) {
        [self.tableLeft setHidden:YES];
        [self.tableV setHidden:NO];
        [self.tableRight setHidden:YES];
        [self.tableV reloadData];
        if (self.dataSource.count<=0) {
            [self requestRanking];
        }
    }else if (index==2) {
        [self.tableLeft setHidden:YES];
        [self.tableV setHidden:YES];
        [self.tableRight setHidden:NO];
        [self.tableRight reloadData];
        if (self.rightDataSource.count<=0) {
            [self.tableRight.mj_header beginRefreshing];
        }
    }else{
        [self.tableLeft setHidden:NO];
        [self.tableV setHidden:YES];
        [self.tableRight setHidden:YES];
        [self.tableLeft reloadData];
    }
}

//添加上方轮播图
-(void)addTopLoopView
{
    //上方的
    self.headView = [HeadBannerView new];
    [self.view addSubview:self.headView];
    
    self.headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(WIDTH_SCALE * 108)
    ;
    [self.headView updateLayout];
    
    self.headView.type = NormalType;
    
    if (self.adArr.count<=1) {
        self.headView.hiddenPageControl = YES;
    }
    [self.headView setupUIWithModels:self.adArr];
    
    @weakify(self)
    self.headView.selectBlock = ^(NSInteger index) {
        GGLog(@"选择了下标为%ld的轮播图",index);
        @strongify(self)
        ADModel *model = self.adArr[index];
        [UniversalMethod jumpWithADModel:model];
    };
    
}

//添加中间的排行视图
-(void)addCenterRankView
{
    //中间的
    LineLayout *layout = [[LineLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(ScreenW, ScreenW/4);
    layout.minimumLineSpacing = 0;
    //速率
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.lineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lineCollectionView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    [self.view addSubview:self.lineCollectionView];
    
    self.lineCollectionView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.adCollectionView, 0)
    ;
    
    _lineCollectionView.dataSource = self;
    _lineCollectionView.delegate = self;
    [_lineCollectionView registerClass:[LineCollectionViewCell class] forCellWithReuseIdentifier:LineCollectionViewCellID];
    
    @weakify(self)
    self.lineCollectionView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.adArr.count<=0) {
            [self requestTopBanner];
        }
        if (self.adDatasource.count<=0) {
            [self requestBottomBanner];
        }
        [self requestRanking];
        
    }];
    
    [self.lineCollectionView.mj_header beginRefreshing];
}

- (void)createTable
{
    self.tableV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableV addBakcgroundColorTheme];
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    self.tableV.showsVerticalScrollIndicator = NO;
    //设置cell的上下内边距
    self.tableV.contentInset = UIEdgeInsetsMake(BCellHeight - SCellHeight, 0, 50, 0);
    //取消cell边框
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableV];
    self.tableV.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    
    [self.tableV registerClass:[MoveCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableV setHidden:YES];
}

-(void)createTableLeft
{
    self.tableLeft = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableLeft addBakcgroundColorTheme];
    self.tableLeft.delegate = self;
    self.tableLeft.dataSource = self;
    self.tableLeft.showsVerticalScrollIndicator = NO;
    //取消cell边框
    self.tableLeft.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableLeft];
    self.tableLeft.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    
    [self.tableLeft registerClass:[RankListTableViewCell2 class] forCellReuseIdentifier:RankListTableViewCell2ID];
    
    @weakify(self);
    self.tableLeft.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestCompanyRanking];
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
    self.tableRight.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableRight];
    self.tableRight.sd_layout
    .topSpaceToView(self.segmentView, 10)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0)
    ;
    //注册
    [self.tableRight registerClass:[MyCollectCasinoCell class] forCellReuseIdentifier:MyCollectCasinoCellID];
    
    @weakify(self);
    self.tableRight.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self requestCompanyList];
    }];
    [self.tableRight setHidden:YES];
    
    self.tableRight.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noCollect" title:@"暂无收藏的娱乐场"];
}

-(void)setRightTableViewHeadView
{
    if (self.rightDataSource.count>0) {
        CompanyDetailModel *model = self.rightDataSource.firstObject;
        if (model.isRecommend) {
            self.tableRight.tableHeaderView = self.rightTableHead;
        }else{
            self.tableRight.tableHeaderView = nil;
        }
//        [self.tableRight reloadData];
    }
}

//添加下方广告视图
-(void)addBottomADView
{
    //下方的
    UICollectionViewFlowLayout *adLayout = [UICollectionViewFlowLayout new];
    adLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat itemW = (ScreenW - 35)/4;
    CGFloat itemH = itemW * 60 / 85;
    adLayout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
    adLayout.itemSize = CGSizeMake(itemW, itemH);
    adLayout.minimumLineSpacing = 5;
    self.adCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:adLayout];
    self.adCollectionView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    [self.view addSubview:self.adCollectionView];
    
    self.adCollectionView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(0)
    ;
    
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    [self.adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ADCellID"];
}

-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        [_naviTitle addBakcgroundColorTheme];
        
        CGFloat wid = 30;
        
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, _naviTitle.height)];
        [_naviTitle addSubview:avatar];
        
        [avatar cornerWithRadius:wid/2];
        avatar.image = UIImageNamed(@"homePage_logo");
        
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        username.text = @"娱乐场排行榜";
        [username sizeToFit];
        CGFloat labelW = CGRectGetWidth(username.frame);
        if (labelW>150*ScaleW) {
            labelW = 150*ScaleW;
        }
        username.frame = CGRectMake(CGRectGetMaxX(avatar.frame) + 5, 0, labelW, 30);
        [_naviTitle addSubview:username];
        
        _naviTitle.frame = CGRectMake(0, 0, 5 * 2 + wid + username.width, 30);
        
        self.navigationItem.titleView = _naviTitle;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.lineCollectionView) {
        return self.dataSource.count;
    }
    return self.adDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView == self.lineCollectionView) {
        LineCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:LineCollectionViewCellID forIndexPath:indexPath];
        RankingModel *model = self.dataSource[indexPath.row];
        cell1.model = model;
        cell = cell1;
    }
    if (collectionView == self.adCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADCellID" forIndexPath:indexPath];
        if (cell.contentView.subviews.count) {
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
            }
        }
        UIImageView *adImg = [UIImageView new];
        [cell.contentView addSubview:adImg];
        adImg.sd_layout
        .leftEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .rightEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        ;
        ADModel *model = self.adDatasource[indexPath.row];
        //        adImg.image = UIImageNamed(self.adDatasource[indexPath.row]);
        [adImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.url))];
    }
    [cell addBakcgroundColorTheme];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.lineCollectionView) {
        RankListViewController *rlVC = [RankListViewController new];
        RankingModel *model = self.dataSource[indexPath.row];
        rlVC.rankingId = model.rankingId;
        rlVC.navigationItem.title = model.rankingName;
        [self.navigationController pushViewController:rlVC animated:YES];
    }else if (collectionView == self.adCollectionView){
        ADModel *model = self.adDatasource[indexPath.row];
        [UniversalMethod jumpWithADModel:model];
    }
}

#pragma mark ---- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableLeft) {
        return self.leftDataSource.count;
    }
    if (tableView == self.tableV) {
        return self.dataSource.count;
    }
    return self.rightDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.tableRight) {
        MyCollectCasinoCell *cell2 = (MyCollectCasinoCell *)[tableView dequeueReusableCellWithIdentifier:MyCollectCasinoCellID];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        CompanyDetailModel *model = self.rightDataSource[indexPath.row];
        cell2.model = model;
        @weakify(self);
        cell2.webPushBlock = ^{
            [[UIApplication sharedApplication] openURL:UrlWithStr(model.website)];
        };
        cell2.detailBlock = ^{
            @strongify(self);
            RankDetailViewController *rdVC = [RankDetailViewController new];
            RankingListModel *model = self.rightDataSource[indexPath.row];
            rdVC.companyId = model.companyId;
            [self.navigationController pushViewController:rdVC animated:YES];
        };
        cell = cell2;
    }else if (tableView == self.tableV) {
        MoveCell *cell1 = [self.tableV dequeueReusableCellWithIdentifier:@"cell"];
        RankingModel *model = self.dataSource[indexPath.row];
        
        [cell1 cellGetModel:model tag:indexPath.row];
        cell = cell1;
    }else{
        RankListTableViewCell2 *cell0 = [self.tableLeft dequeueReusableCellWithIdentifier:RankListTableViewCell2ID];
        cell0.tag = indexPath.row;
        cell0.model = self.leftDataSource[indexPath.row];
        @weakify(self);
        cell0.toPlayBlock = ^(NSInteger index){
            @strongify(self);
            RankingListModel *model = self.leftDataSource[index];
            //记得去掉首尾空格
            [[UIApplication sharedApplication] openURL:UrlWithStr([NSString deleteHeadAndFootSpace:model.website])];
        };
        
        cell = cell0;
    }
    [cell addBakcgroundColorTheme];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableLeft) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.tableLeft.frame.size.width tableView:tableView];
    }
    if (tableView == self.tableV) {
        return SCellHeight;
    }
    return 70;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%.2f", cell.frame.origin.y);
    //cell第一次出现时调用计算偏移量
    if (tableView == self.tableV) {
        MoveCell *getCell = (MoveCell *)cell;
        
        [getCell cellOffsetOnTabelView:tableView];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableV) {
        RankListViewController *rlVC = [RankListViewController new];
        RankingModel *model = self.dataSource[indexPath.row];
        rlVC.rankingId = model.rankingId;
        rlVC.navigationItem.title = model.rankingName;
        [self.navigationController pushViewController:rlVC animated:YES];
    }else if (tableView == self.tableLeft) {
        RankDetailViewController *rdVC = [RankDetailViewController new];
        RankingListModel *model = self.leftDataSource[indexPath.row];
        rdVC.companyId = model.companyId;
        [self.navigationController pushViewController:rdVC animated:YES];
    }
    
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyDetailModel *model = self.rightDataSource.firstObject;
    BOOL canEdit = YES;
    if (model.isRecommend) {
        canEdit = NO;
    }
    if (self.segmentView.selectedIndex == 2&&canEdit == YES) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyDetailModel *model = self.rightDataSource.firstObject;
    BOOL canEdit = YES;
    if (model.isRecommend) {
        canEdit = NO;
    }
    if (self.segmentView.selectedIndex == 2&&canEdit == YES) {
        //添加取消收藏按钮
        UITableViewRowAction *cancelCollectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            CompanyDetailModel *model = self.rightDataSource[indexPath.row];
            [self.deleteArray addObject:model];
//            [self requestConcernCompany:model];
            [self requestCancelCompanysCollects];
        }];
        
        cancelCollectAction.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            UITableViewRowAction *btn = item;
            if (UserGetBool(@"NightMode")) {
                btn.backgroundColor = HexColor(#6A7C8D);
            }else{
                btn.backgroundColor = HexColor(#51AAFF);
            }
        });
        
        return @[cancelCollectAction];
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableV) {
        //在滑动过程中获取当前显示的所有cell, 调用偏移量的计算方法
        [[self.tableV visibleCells] enumerateObjectsUsingBlock:^(MoveCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //cell偏移设置
            [obj cellOffsetOnTabelView:self.tableV];
            
        }];
    }
}


#pragma mark ----- 请求发送
//请求上部广告
-(void)requestTopBanner
{
    [RequestGather requestBannerWithADId:7 success:^(id response) {
        self.adArr = response;
//        CGFloat headHeight = WIDTH_SCALE * 108 + 30;
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
            
        }
//        self.tableV.sd_resetLayout
//        .leftEqualToView(self.view)
//        .rightEqualToView(self.view)
//        .topSpaceToView(self.view, headHeight)
//        .bottomSpaceToView(self.adCollectionView, 0)
//        ;
        
    } failure:nil];
}

//请求下部广告
-(void)requestBottomBanner
{
    [RequestGather requestBannerWithADId:5 success:^(id response) {
        self.adDatasource = response;
        CGFloat adViewHeight = 0;
        CGFloat itemW = (ScreenW - 35)/4;
        CGFloat itemH = itemW * 60 / 85;
        if (!kArrayIsEmpty(self.adDatasource)) {
            adViewHeight = 30 + itemH;
        }
        self.adCollectionView.sd_resetLayout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view)
        .heightIs(adViewHeight)
        ;
        
        [self.adCollectionView reloadData];
    } failure:nil];
}

//请求排行榜
-(void)requestRanking
{
    [HttpRequest getWithURLString:Ranking parameters:nil success:^(id responseObject) {
        NSArray *data = [RankingModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (!kArrayIsEmpty(data)) {
            self.dataSource = [data mutableCopy];
        }
        //        [self.lineCollectionView.mj_header endRefreshing];
        //        [self.lineCollectionView reloadData];
        [self.tableV reloadData];
    } failure:^(NSError *error) {
        //        [self.lineCollectionView.mj_header endRefreshing];
    }];
}

//请求综合排名
-(void)requestCompanyRanking
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"rankingId"] = @(-1);
    
    [HttpRequest getWithURLString:CompanyRanking parameters:parameters success:^(id responseObject) {
        NSArray *data = [RankingListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"data"]];
        [self.tableLeft.mj_header endRefreshing];
        self.leftDataSource = [data mutableCopy];
        
        [self.tableLeft reloadData];
    } failure:^(NSError *error) {
        [self.tableLeft.mj_header endRefreshing];
    }];
    
}

//收藏娱乐城列表
-(void)requestCompanyList
{
    [self.tableRight ly_startLoading];
    @weakify(self)
    [HttpRequest getWithURLString:ListConcernedCompanyForUser parameters:nil success:^(id responseObject) {
        @strongify(self)
        self.rightDataSource = [CompanyDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self setRightTableViewHeadView];
        [self.tableRight.mj_header endRefreshing];
        [self.tableRight reloadData];
        [self.tableRight ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableRight endAllRefresh];
    }];
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
    
    [HttpRequest postWithURLString:CancelCompanysCollects parameters:@{@"companyIds":jsonString} isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        
        //将数据源数组中包含有删除数组中的数据删除掉
        [self.rightDataSource removeObjectsInArray:self.deleteArray];
        //清空删除数组
        [self.deleteArray removeAllObjects];
        
        [self.tableRight reloadData];
        [self.tableRight ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableRight endAllRefresh];
        [self.tableRight ly_endLoading];
    } RefreshAction:nil];
    
}

//收藏、取消收藏公司(娱乐城)
-(void)requestConcernCompany:(CompanyDetailModel *)model
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"companyId"] = GetSaveString(model.companyId);
    [HttpRequest postWithURLString:ConcernCompany parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        [self.rightDataSource removeObject:model];
        [self.tableRight reloadData];
        [self.tableRight ly_endLoading];
    } failure:nil RefreshAction:nil];
}

@end
