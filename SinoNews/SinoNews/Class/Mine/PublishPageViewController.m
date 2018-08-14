//
//  PublishPageViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishPageViewController.h"
#import "PublishViewController.h"
#import "CommentManagerViewController.h"
#import "PublishManagerViewController.h"
#import "NewPublishManagerVC.h"

@interface PublishPageViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@end

@implementation PublishPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTopLine];
    
    [self reloadChildVCWithTitles:@[
                                    @"发布",
                                    @"评论管理",
                                    @"发布管理",
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
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 44) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.4;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#323232);
    _segHead.deSelectColor = HexColor(#323232);
    _segHead.maxTitles = 3;
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
        //来回滑动一次，解决显示问题
        [(MLMSegmentHead *)item changeIndex:1 completion:YES];
        [(MLMSegmentHead *)item changeIndex:0 completion:YES];
    });
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    PublishViewController *pvc = [PublishViewController new];
    CommentManagerViewController *cmvc = [CommentManagerViewController new];
//    PublishManagerViewController *pmvc = [PublishManagerViewController new];
    NewPublishManagerVC *npmVC = [NewPublishManagerVC new];
    
    [arr addObjectsFromArray:@[
                               pvc,
                               cmvc,
//                               pmvc,
                               npmVC,
                               ]];
    return arr;
}


@end
