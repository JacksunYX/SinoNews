//
//  MyPostViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "MyPostViewController.h"
#import "PostingListViewController.h"
#import "CommentManagerViewController.h"

@interface MyPostViewController ()<MLMSegmentHeadDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) NSMutableArray *vcArr;

@end

@implementation MyPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的帖子";
    [self setTopLineColor:CutLineColor];
    self.view.backgroundColor = WhiteColor;
    
    [self setUI];
}

-(void)setUI
{
    [self reloadChildVCWithTitles:@[
                                    @"我的发帖",
                                    @"我的回复",
                                    @"我的草稿",
                                    ]];
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 34) titles:titles headStyle:1 layoutStyle:0];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.3;
    _segHead.fontSize = 14;
    _segHead.lineHeight = 1;
    _segHead.maxTitles = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    _segHead.deSelectColor = HexColor(#161A24);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 1;
    _segHead.bottomLineColor = CutLineColor;
    _segHead.singleW_Add = 50;
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
    PostingListViewController *plVC1 = [PostingListViewController new];
    CommentManagerViewController *tplVC = [CommentManagerViewController new];
    tplVC.type = 1;
    PostingListViewController *plVC2 = [[PostingListViewController alloc]init];
    plVC2.type = 1;
    
    [_vcArr addObject:plVC1];
    [_vcArr addObject:tplVC];
    [_vcArr addObject:plVC2];
    return _vcArr;
}


#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    GGLog(@"当前下标:%ld",index);
    
}



@end
