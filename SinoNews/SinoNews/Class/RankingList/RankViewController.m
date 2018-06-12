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
        NSArray *title = @[
                           @"综合排行",
                           @"体育投注排行",
                           @"真人游戏排行",
                           @"男性玩家排行",
                           @"女性玩家排行",
                           @"未成年玩家排行",
                           ];
        NSArray *backImg = @[
                                @"rank_banner0",
                                @"rank_banner1",
                                @"rank_banner2",
                                @"rank_banner3",
                                @"rank_banner0",
                                @"rank_banner1",
                                ];
        
        NSArray *updateTime = @[
                                   @"2018年5月30日",
                                   @"2018年5月31日",
                                   @"2018年5月15日",
                                   @"2018年6月1日",
                                   @"2018年4月23日",
                                   @"2018年1月1日",
                                   ];
        _datasource = [NSMutableArray new];
        
        for (int i = 0; i < title.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"title"] = title[i];
            dic[@"backImg"] = backImg[i];
            dic[@"updateTime"] = updateTime[i];
            [_datasource addObject:dic];
        }
        
    }
    return _datasource;
}

-(NSMutableArray *)adDatasource
{
    if (!_adDatasource) {
        _adDatasource  = [NSMutableArray new];
        for (int i = 0; i < 4; i ++) {
            NSString *imgStr = [NSString stringWithFormat:@"ad_banner%d",i];
            [_adDatasource addObject:imgStr];
        }
    }
    return _adDatasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"排行榜";
    [self requestBanner];
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
    .heightIs(WIDTH_SCALE * 108 + 15)
    ;
    [self.headView updateLayout];
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (int i = 0; i < self.adArr.count; i ++) {
        ADModel *model = self.adArr[i];
        [imgs addObject:model.url];
    }
    self.headView.type = NormalType;
    [self.headView setupUIWithImageUrls:imgs];
    
    WEAK(weakSelf, self);
    self.headView.selectBlock = ^(NSInteger index) {
        GGLog(@"选择了下标为%ld的轮播图",index);
        ADModel *model = weakSelf.adArr[index];
        [[UIApplication sharedApplication] openURL:UrlWithStr(model.redirectUrl)];
    };

}

//添加中间的排行视图
-(void)addCenterRankView
{
    //中间的
    LineLayout *layout = [[LineLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 50, 20);
    layout.itemSize = CGSizeMake(ScreenW - 40, WIDTH_SCALE * 120);
    layout.minimumLineSpacing = 10;
    //速率
    layout.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.lineCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.lineCollectionView.backgroundColor = WhiteColor;
    [self.view addSubview:self.lineCollectionView];
    [self.lineCollectionView activateConstraints:^{
//        self.lineCollectionView.top_attr = self.headView.bottom_attr;
        [self.lineCollectionView.top_attr equalTo:self.view.top_attr_safe constant:WIDTH_SCALE * 108 + 15];
        self.lineCollectionView.left_attr = self.view.left_attr_safe;
        self.lineCollectionView.right_attr = self.view.right_attr_safe;
        self.lineCollectionView.bottom_attr = self.adCollectionView.top_attr;
    }];
    
    _lineCollectionView.dataSource = self;
    _lineCollectionView.delegate = self;
    [_lineCollectionView registerClass:[LineCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    WeakSelf
    self.lineCollectionView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        GCDAfterTime(2, ^{
            [weakSelf.lineCollectionView.mj_footer endRefreshingWithNoMoreData];
        });
    }];
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
    self.adCollectionView.backgroundColor = WhiteColor;
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.lineCollectionView) {
        return self.datasource.count;
    }
    return self.adDatasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if (collectionView == self.lineCollectionView) {
        LineCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        NSDictionary *model = self.datasource[indexPath.row];
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
        adImg.image = UIImageNamed(self.adDatasource[indexPath.row]);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.lineCollectionView) {
        RankListViewController *rlVC = [RankListViewController new];
        [self.navigationController pushViewController:rlVC animated:YES];
    }
}

//请求banner
-(void)requestBanner
{
    [HttpRequest getWithURLString:Adverts parameters:@{@"advertsPositionId":@1} success:^(id responseObject) {
        self.adArr = [NSMutableArray arrayWithArray:[ADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
        }
        
    } failure:nil];
    
}



@end
