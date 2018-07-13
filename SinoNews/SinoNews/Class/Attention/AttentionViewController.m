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

@interface AttentionViewController ()
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(searchAction) image:@"attention_search" hightimage:@"attention_search" andTitle:@""];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(recommandAction) image:@"manageMenu" hightimage:nil andTitle:@""];
    if (CompareString(UserGet(@"isLogin"), @"YES")) {
        
    }
    [self reloadChildVCWithTitles:@[@"作者",@"频道"]];
    
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
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
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        weakself.navigationItem.titleView = weakself.segHead;
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
}

- (NSArray *)getvcArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < 2; i ++) {
        HomePageChildVCViewController *vc = [HomePageChildVCViewController new];
        if (i == 0) {
           vc.news_id = @"作者";
        }else if (i == 1){
            vc.news_id = @"频道";
        }
        
        [arr addObject:vc];
    }
    return arr;
}











@end
