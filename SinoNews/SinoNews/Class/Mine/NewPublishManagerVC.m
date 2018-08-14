//
//  NewPublishManagerVC.m
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NewPublishManagerVC.h"
#import "PublishManagerViewController.h"

@interface NewPublishManagerVC ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation NewPublishManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadChildVCWithTitles:@[
                                    @"已审核",
                                    @"待审核",
                                    @"草稿箱",
                                    ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.6;
    _segHead.fontSize = 14;
    _segHead.lineHeight = 2;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    _segHead.deSelectColor = HexColor(#888888);
    _segHead.maxTitles = 3;
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = CutLineColorNight;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.view.bounds.size.height - 44 - BOTTOM_MARGIN) vcOrViews:[self vcArr:titles.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.view addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
        //来回滑动一次，解决显示问题
        [(MLMSegmentHead *)item changeIndex:1 completion:YES];
        [(MLMSegmentHead *)item changeIndex:0 completion:YES];
    });
}

//创建控制器数组
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        PublishManagerViewController *pmvc = [PublishManagerViewController new];
        pmvc.type = i;
        [arr addObject:pmvc];
    }
    return arr;
}




@end
