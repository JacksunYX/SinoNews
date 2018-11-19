//
//  CommunitySearchVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "CommunitySearchVC.h"
#import "ThePostListViewController.h"
#import "TheAuthorListViewController.h"
#import "UserAttentionOrFansVC.h"


@interface CommunitySearchVC ()<MLMSegmentHeadDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) NSMutableArray *vcArr;
@end

@implementation CommunitySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索版块";
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

-(void)setUI
{
    [self reloadChildVCWithTitles:@[@"帖子",@"作者"]];
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 34) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.1;
    _segHead.fontSize = 15;
    _segHead.lineHeight = 2;
    _segHead.maxTitles = 4;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#161A24);
    _segHead.deSelectColor = HexColor(#161A24);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = CutLineColorNight;
//    _segHead.singleW_Add = 50;
    _segHead.delegate = self;
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - CGRectGetHeight(_segHead.frame)) vcOrViews:[self getvcArrWith:titles]];
    _segScroll.countLimit = 0;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        @strongify(self);
        [self.view addSubview:self.segHead];
        [self.view addSubview:self.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    
}

- (NSArray *)getvcArrWith:(NSArray *)titles
{
    _vcArr = [NSMutableArray array];
    ThePostListViewController *tplVC = [ThePostListViewController new];
    tplVC.keyword = self.keyword;
//    TheAuthorListViewController *talVC = [TheAuthorListViewController new];
    UserAttentionOrFansVC *uaofVC = [UserAttentionOrFansVC new];
    uaofVC.type = 1;
    uaofVC.userId = [UserModel getLocalUserModel].userId;
    [_vcArr addObject:tplVC];
    [_vcArr addObject:uaofVC];
    return _vcArr;
}


#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
//    GGLog(@"当前下标:%ld",index);
    if (index!=0) {
        ThePostListViewController *tplVC = (ThePostListViewController *)_vcArr[0];
        [tplVC hiddenMenu];
    }
}

@end
