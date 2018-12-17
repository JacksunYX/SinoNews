//
//  StoreViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreChildViewController.h"
#import "HeadBannerView.h"
#import "ADModel.h"

@interface StoreViewController ()
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@property (nonatomic,strong) NSMutableArray *adArr; //轮播广告数组
//分页联动
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic,strong) NSArray *categoryArr;

@end

@implementation StoreViewController
-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商城";
    
    @weakify(self);
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noProduct" refreshBlock:^{
        @strongify(self);
        [self requestBanner];
        [self requestMallcCategory];
    }];
    
    [self requestBanner];
    [self requestMallcCategory];
    
    //监听登录
//    @weakify(self)
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        @strongify(self)
//
//    }];
    
//    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noProduct" title:@"无商品"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GGLog(@"商城界面出现了");
}

//添加上方轮播图
-(void)addTopLoopView
{
    //上方的
    self.headView = [HeadBannerView new];
    [self.view addSubview:self.headView];
    
    self.headView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(WIDTH_SCALE * 108)
    ;
    [self.headView updateLayout];
    
    self.headView.type = NormalType;
    self.headView.bottomHeight = 5;
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

//添加分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, WIDTH_SCALE * 108 + 20 , SCREEN_WIDTH, 42) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
//    _segHead.selectColor = HexColor(#323232);
    
    _segHead.bottomLineHeight = 1;
    _segHead.deSelectColor = HexColor(#888888);
    _segHead.maxTitles = 4;
    
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT - CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:titles.count]];
    _segScroll.addTiming = SegmentAddScale;
    _segScroll.addScale = 0.3;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.view addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
        
        if (UserGetBool(@"NightMode")) {
            [(MLMSegmentHead *)item setBottomLineColor:CutLineColorNight];
        }else{
            [(MLMSegmentHead *)item setBottomLineColor:CutLineColor];
        }
    });
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        StoreChildViewController *vc = [StoreChildViewController new];
        vc.categoryId = [self.categoryArr[i][@"categoryId"] integerValue];
        [arr addObject:vc];
    }
    return arr;
}

#pragma mark ---- 请求发送
//请求banner
-(void)requestBanner
{
    [self.view ly_startLoading];
    [RequestGather requestBannerWithADId:8 success:^(id response) {
        self.adArr = response;
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
        }
    } failure:^(NSError *error) {
        [self.view ly_endLoading];
    }];
}

//请求商品分类
-(void)requestMallcCategory
{
    [HttpRequest getWithURLString:Mall_category parameters:@{} success:^(id responseObject) {
        self.categoryArr = responseObject[@"data"];
        NSMutableArray *titleArr = [NSMutableArray new];
        for (NSDictionary *dic in self.categoryArr) {
            [titleArr addObject:GetSaveString([dic objectForKey:@"categoryName"])];
        }
        if (titleArr.count > 0) {
            [self reloadChildVCWithTitles:titleArr];
        }
    } failure:nil];
}






@end
