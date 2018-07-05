//
//  IntegralViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "IntegralViewController.h"
#import "StoreViewController.h"
#import "GameViewController.h"
#import "RechargeViewController.h"
#import "ManagerViewController.h"

@interface IntegralViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    
    [self reloadChildVCWithTitles:@[
                                    @"商城",
                                    @"游戏",
                                    @"充值",
                                    @"管理",
                                    ]];
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
    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    _segHead.deSelectColor = HexColor(#7B7B7B);
    _segHead.maxTitles = 4;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    _segHead.showIndex = self.selectedIndex;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self vcArr:titles.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
        [weakself.view addSubview:weakself.segScroll];
    }];

}

-(void)setSelectIndex:(NSInteger)index
{
    self.selectedIndex = index;
    if (self.segHead) {
        [self.segHead changeIndex:index completion:YES];
    }
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    StoreViewController *svc = [StoreViewController new];
    GameViewController *gvc = [GameViewController new];
    RechargeViewController *rvc = [RechargeViewController new];
    ManagerViewController *mvc = [ManagerViewController new];
    [arr addObjectsFromArray:@[
                               svc,
                               gvc,
                               rvc,
                               mvc,
                               ]];
    return arr;
}









@end
