//
//  NewRankViewController.m
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/6/26.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "NewRankViewController.h"
#import "SearchViewController.h"
#import "RankViewController.h"

#import "HeadBannerView.h"

@interface NewRankViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@property (nonatomic,strong) NSMutableArray *adArr; //轮播广告数组

@end

@implementation NewRankViewController

-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenTopLine];
    [self addNavigationView];
    [self reloadChildVCWithTitles:@[
                                    @"热门内容",
                                    @"娱乐场排行",
                                    ]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.adArr.count<=0) {
        [self requestTopBanner];
    }
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

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 44) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.3;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 2;
    _segHead.lineColor = ThemeColor;
    _segHead.selectColor = ThemeColor;
    _segHead.deSelectColor = HexColor(#1a1a1a);
    _segHead.maxTitles = 2;
    _segHead.bottomLineHeight = 0;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    CGFloat scrollH =  SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT - WIDTH_SCALE * 108 - 10;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, WIDTH_SCALE * 108 + 5, SCREEN_WIDTH,scrollH) vcOrViews:[self vcArr:titles.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
        [weakself.view addSubview:weakself.segScroll];
    }];
//    [_segHead.titlesScroll addBakcgroundColorTheme];
//    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
//        [(MLMSegmentHead *)item setSelectColor:value];
//    });
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    BaseViewController *vc1 = [BaseViewController new];
    RankViewController *vc2 = [RankViewController new];
    [arr addObjectsFromArray:@[
                               vc1,
                               vc2,
                               ]];
    return arr;
}

//添加上方轮播图
-(void)addTopLoopView
{
    //上方的
    self.headView = [HeadBannerView new];
    [self.view addSubview:self.headView];
    
    self.headView.sd_layout
//    .topEqualToView(self.view)
    .topSpaceToView(self.view, 5)
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

@end
