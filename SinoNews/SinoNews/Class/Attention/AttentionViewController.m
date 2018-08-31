//
//  AttentionViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionViewController.h"
#import "SearchViewController.h"    //搜索页面
#import "HomePageChildVCViewController.h"
#import "AttentionRecommendVC.h"
#import "CasinoCollectViewController.h"

@interface AttentionViewController ()<MLMSegmentHeadDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    
    [self addNavigationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *rightImg = @"manageMenu";
        NSString *leftImg = @"attention_search";
        if (UserGetBool(@"NightMode")) {
            rightImg = [rightImg stringByAppendingString:@"_night"];
            leftImg = [leftImg stringByAppendingString:@"_night"];
        }
        
        self.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(recommandAction) image:UIImageNamed(rightImg)];
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        
        self.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(leftImg)];
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
        
        self.leftBarButtonItem.customView.hidden = self.segHead.index;
        self.rightBarButtonItem.customView.hidden = self.segHead.index;
    });
    
    if (CompareString(UserGet(@"isLogin"), @"YES")) {
        
    }
    [self reloadChildVCWithTitles:@[@"作者",@"娱乐场"]];
    
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
    sVC.selectIndex = 2;
    [self.navigationController pushViewController:sVC animated:NO];
}

-(void)recommandAction
{
    AttentionRecommendVC *arVC = [AttentionRecommendVC new];
    [self.navigationController pushViewController:arVC animated:YES];
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 180, 40) titles:titles headStyle:1 layoutStyle:1];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.5;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.delegate = self;
    
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
//    _segHead.deSelectColor = HexColor(#323232);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.maxTitles = titles.count;
    _segHead.bottomLineHeight = 0;
    _segHead.singleW_Add = 50;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self getvcArr]];
    _segScroll.countLimit = 0;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        @strongify(self);
        self.navigationItem.titleView = self.segHead;
        [self.view addSubview:self.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    
}

- (NSArray *)getvcArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i ++) {
        
        if (i == 0) {
            HomePageChildVCViewController *vc = [HomePageChildVCViewController new];
            vc.news_id = @"作者";
            [arr addObject:vc];
        }else if (i == 1){
            CasinoCollectViewController *ccVC = [CasinoCollectViewController new];
            [arr addObject:ccVC];
        }
        
    }
    return arr;
}

#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    self.leftBarButtonItem.customView.hidden = index;
    self.rightBarButtonItem.customView.hidden = index;
}









@end
