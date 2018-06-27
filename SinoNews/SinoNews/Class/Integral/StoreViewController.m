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
    self.view.backgroundColor = WhiteColor;
    
    [self requestBanner];
    
    [self reloadChildVCWithTitles:@[
                                    @"筹码",
                                    @"优惠",
                                    @"充值卡",
                                    @"实惠",
                                    ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//添加上方轮播图
-(void)addTopLoopView
{
    //上方的
    self.headView = [HeadBannerView new];
    [self.view addSubview:self.headView];
    
    self.headView.sd_layout
    .topSpaceToView(self.view, 10)
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

//添加分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, WIDTH_SCALE * 108 + 15, SCREEN_WIDTH, 42) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#323232);
    _segHead.deSelectColor = HexColor(#888888);
    _segHead.maxTitles = 4;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT - CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:titles.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.view addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        StoreChildViewController *vc = [StoreChildViewController new];
        vc.index = i;
        [arr addObject:vc];
    }
    return arr;
}

//请求banner
-(void)requestBanner
{
    [HttpRequest getWithURLString:Adverts parameters:@{@"advertsPositionId":@1} success:^(id responseObject) {
        self.adArr = [NSMutableArray arrayWithArray:[ADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"advertsList"]]];
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
        }
        
    } failure:nil];
    
}

@end
