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

@interface StoreViewController ()
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
//分页联动
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商城";
    self.view.backgroundColor = WhiteColor;
    
    [self addTopLoopView];
    
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
    for (int i = 0; i < 4; i ++) {
        NSString *imgStr = [NSString stringWithFormat:@"banner%d",i];
        [imgs addObject:imgStr];
    }
    self.headView.type = NormalType;
    [self.headView setupUIWithImageUrls:imgs];
    
    self.headView.selectBlock = ^(NSInteger index) {
        DLog(@"选择了下标为%ld的轮播图",index);
    };
}

//添加分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView.frame), SCREEN_WIDTH, 42) titles:titles headStyle:1 layoutStyle:0];
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



@end
