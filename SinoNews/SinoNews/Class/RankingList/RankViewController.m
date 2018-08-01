//
//  RankViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankViewController.h"
#import "RankListViewController.h"
#import "ADModel.h"

#import "HeadBannerView.h"
#import "LineCollectionViewCell.h"
#import "LineLayout.h"


@interface RankViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@property (nonatomic,strong) NSMutableArray *adArr; //轮播广告数组
//中间的排行视图
@property (nonatomic, strong) UICollectionView *lineCollectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
//下方广告视图
@property (nonatomic ,strong) UICollectionView *adCollectionView;
@property (nonatomic ,strong) NSMutableArray *adDatasource;

@property (nonatomic,strong) UIView *naviTitle;
@end

@implementation RankViewController
-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

-(NSMutableArray *)datasource
{
    if (!_datasource) {
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
        _datasource = [NSMutableArray new];
//
//        for (int i = 0; i < title.count; i ++) {
//            NSMutableDictionary *dic = [NSMutableDictionary new];
//            dic[@"title"] = title[i];
//            dic[@"backImg"] = backImg[i];
//            dic[@"updateTime"] = updateTime[i];
//            [_datasource addObject:dic];
//        }
        
    }
    return _datasource;
}

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
//        for (int i = 0; i < 4; i ++) {
//            NSString *imgStr = [NSString stringWithFormat:@"ad_banner%d",i];
//            [_adDatasource addObject:imgStr];
//        }
    }
    return _adDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"排行榜";
    
    [self setNaviTitle];
    
    [self addViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//添加视图
-(void)addViews
{
    [self addTopLoopView];
    [self addBottomADView];
    [self addCenterRankView];
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
    .heightIs(WIDTH_SCALE * 108 + 30)
    ;
    [self.headView updateLayout];
    
    self.headView.type = NormalType;
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
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    layout.itemSize = CGSizeMake(ScreenW, WIDTH_SCALE * 120);
    layout.minimumLineSpacing = 0;
    //速率
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.lineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lineCollectionView.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    [self.view addSubview:self.lineCollectionView];
    [self.lineCollectionView activateConstraints:^{
//        self.lineCollectionView.top_attr = self.headView.bottom_attr;
        [self.lineCollectionView.top_attr equalTo:self.view.top_attr_safe constant:WIDTH_SCALE * 108 + 30];
        self.lineCollectionView.left_attr = self.view.left_attr_safe;
        self.lineCollectionView.right_attr = self.view.right_attr_safe;
        self.lineCollectionView.bottom_attr = self.adCollectionView.top_attr;
    }];
    
    _lineCollectionView.dataSource = self;
    _lineCollectionView.delegate = self;
    [_lineCollectionView registerClass:[LineCollectionViewCell class] forCellWithReuseIdentifier:LineCollectionViewCellID];
    
    @weakify(self)
    self.lineCollectionView.mj_header = [YXNormalHeader headerWithRefreshingBlock:^{
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
    [self.adCollectionView activateConstraints:^{
        self.adCollectionView.bottom_attr = self.view.bottom_attr_safe;
        self.adCollectionView.left_attr = self.view.left_attr_safe;
        self.adCollectionView.right_attr = self.view.right_attr_safe;
        self.adCollectionView.height_attr.constant = 30 + itemH;
    }];
    
    self.adCollectionView.dataSource = self;
    self.adCollectionView.delegate = self;
    [self.adCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ADCellID"];
}

-(void)setNaviTitle
{
    if (!_naviTitle) {
        _naviTitle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        self.navigationItem.titleView = _naviTitle;
        [_naviTitle addBakcgroundColorTheme];
        
        UIImageView *avatar = [UIImageView new];
        UILabel *username = [UILabel new];
        [username addTitleColorTheme];
        
        [_naviTitle sd_addSubviews:@[
                                     avatar,
                                     username,
                                     ]];
        CGFloat wid = 30;

        avatar.sd_layout
        .leftEqualToView(_naviTitle)
        .centerYEqualToView(_naviTitle)
        .widthIs(wid)
        .heightIs(30)
        ;
        [avatar setSd_cornerRadius:@(wid/2)];
        [avatar setImage:UIImageNamed(@"homePage_logo")];
        
        username.sd_layout
        .leftSpaceToView(avatar, 5)
        .centerYEqualToView(_naviTitle)
        .heightIs(30)
        ;
        [username setSingleLineAutoResizeWithMaxWidth:120];
        username.text = @"启世录TOPS";
        
//        [_naviTitle setupAutoWidthWithRightView:username rightMargin:5];
        
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.lineCollectionView) {
        return self.datasource.count;
    }
    return self.adDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView == self.lineCollectionView) {
        LineCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:LineCollectionViewCellID forIndexPath:indexPath];
        RankingModel *model = self.datasource[indexPath.row];
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
        RankingModel *model = self.datasource[indexPath.row];
        rlVC.rankingId = model.rankingId;
        rlVC.navigationItem.title = model.rankingName;
        [self.navigationController pushViewController:rlVC animated:YES];
    }else if (collectionView == self.adCollectionView){
        ADModel *model = self.adDatasource[indexPath.row];
        [UniversalMethod jumpWithADModel:model];
    }
}

#pragma mark ----- 请求发送
//请求上部广告
-(void)requestTopBanner
{
    [RequestGather requestBannerWithADId:7 success:^(id response) {
        self.adArr = response;
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
        }
    } failure:nil];
}

//请求下部广告
-(void)requestBottomBanner
{
    [RequestGather requestBannerWithADId:5 success:^(id response) {
        self.adDatasource = response;
        [self.adCollectionView reloadData];
    } failure:nil];
}

//请求排行榜
-(void)requestRanking
{
    [HttpRequest getWithURLString:Ranking parameters:nil success:^(id responseObject) {
        NSArray *data = [RankingModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (!kArrayIsEmpty(data)) {
            self.datasource = [data mutableCopy];
        }
        [self.lineCollectionView.mj_header endRefreshing];
        [self.lineCollectionView reloadData];
    } failure:^(NSError *error) {
        [self.lineCollectionView.mj_header endRefreshing];
    }];
}

@end
