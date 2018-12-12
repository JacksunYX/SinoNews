//
//  PointsViewController.m
//  SinoNews
//
//  Created by Michael on 2018/12/11.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PointsViewController.h"
#import "RechargeViewController.h"
#import "PointsCashViewController.h"

@interface PointsViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation PointsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadChildVCWithTitles:@[
                                    @"充值积分",
                                    @"积分提现",
                                    ]];
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
    //    _segHead.deSelectColor = HexColor(#7B7B7B);
    
    _segHead.maxTitles = 4;
    
    _segHead.bottomLineHeight = 0;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self vcArr:titles.count]];
    _segScroll.addTiming = SegmentAddScale;
    _segScroll.addScale = 0.3;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        
        if (UserGetBool(@"NightMode")) {
            [(MLMSegmentHead *)item setDeSelectColor:value];
            [(MLMSegmentHead *)item setBottomLineColor:CutLineColorNight];
        }else{
            [(MLMSegmentHead *)item setDeSelectColor:HexColor(#7B7B7B)];
            [(MLMSegmentHead *)item setBottomLineColor:CutLineColor];
        }
    });
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    RechargeViewController *rVC = [RechargeViewController new];
    PointsCashViewController *pcVC = [PointsCashViewController new];

    [arr addObjectsFromArray:@[
                               rVC,
                               pcVC,
                               
                               ]];
    return arr;
}

@end
