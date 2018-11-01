//
//  ReadThePostMainVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadThePostMainVC.h"
#import "ReadPostChildViewController.h"

#import "XLChannelControl.h"        //频道管理页面

@interface ReadThePostMainVC ()<MLMSegmentHeadDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, strong) NSMutableArray *titleList; //频道数组
@end

@implementation ReadThePostMainVC
-(NSMutableArray *)titleList
{
    if (!_titleList) {
        _titleList = [NSMutableArray new];
        NSArray *titles = @[
                            @"关注",
                            @"直播",
                            @"全部",
                            @"航空",
                            @"酒店",
                            @"信用卡",
                            ];
        for (int i = 0; i < titles.count; i ++) {
            XLChannelModel *model = [XLChannelModel new];
            model.channelName = titles[i];
            if (i == 0) {
                model.status = 2;
            }
            [_titleList addObject:model];
        }
    }
    return _titleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self hiddenTopLine];
    
    [self addNavigationView];
    
    [self reloadChildVCWithTitles:@[
                                    @"酒店",
                                    @"全部",
                                    @"航空",
                                    @"信用卡",
                                    @"测试1",
                                    @"测试2",
                                    @"测试3",
                                    ]];
}


//修改导航栏显示
-(void)addNavigationView
{
    _customTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
//    _customTitleView.backgroundColor = RedColor;
    self.navigationItem.titleView = _customTitleView;
    
    //切换频道和搜索按钮
    UIButton *addChannel = [UIButton new];
    UIButton *search = [UIButton new];
//    addChannel.backgroundColor = Arc4randomColor;
//    search.backgroundColor = Arc4randomColor;
    
    [_customTitleView sd_addSubviews:@[
                                       search,
                                       addChannel,
                                       ]];
    search.sd_layout
    .rightEqualToView(_customTitleView)
    .centerYEqualToView(_customTitleView)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [search setNormalImage:UIImageNamed(@"attention_search")];
    
    addChannel.sd_layout
    .centerYEqualToView(_customTitleView)
    .rightSpaceToView(search, 0)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    [addChannel setNormalImage:UIImageNamed(@"bankCard_addIcon")];
    [addChannel addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sepLine = [UIView new];
//    sepLine.backgroundColor = kWhite(0.1);
    [_customTitleView addSubview:sepLine];
    sepLine.sd_layout
    .rightSpaceToView(_customTitleView, 85)
    .centerYEqualToView(_customTitleView)
    .widthIs(1)
    .heightIs(20)
    ;
    //添加阴影
    sepLine.layer.shadowColor = GrayColor.CGColor;
    sepLine.layer.shadowOffset = CGSizeMake(-5, 0);
    sepLine.layer.shadowOpacity = 1;
    sepLine.layer.shouldRasterize = NO;
    sepLine.layer.shadowPath = [UIBezierPath bezierPathWithRect:sepLine.bounds].CGPath;
}

-(void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 90, 44) titles:titles headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.2;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 2;
    _segHead.maxTitles = 4;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    //    _segHead.deSelectColor = HexColor(#323232);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 0;
    _segHead.singleW_Add = 40;
    _segHead.delegate = self;
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self getvcArrWith:titles]];
    _segScroll.countLimit = 0;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        @strongify(self);
        [self.customTitleView addSubview:self.segHead];
        [self.view addSubview:self.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    
}

- (NSArray *)getvcArrWith:(NSArray *)titles
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i ++) {
        
        ReadPostChildViewController *vc = [ReadPostChildViewController new];
        
        [arr addObject:vc];
        
    }
    return arr;
}

//全部频道
-(void)more:(UIButton *)btn
{
    @weakify(self)
    XLChannelControl *xccc = [XLChannelControl shareControl];
    xccc.naviTitle = @"全部版块";
    xccc.cannotDelete = YES;
    [xccc showChannelViewWithInUseTitles:self.titleList unUseTitles:nil finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        @strongify(self)
        GGLog(@"返回标题数组:%@",inUseTitles);
        
        
    } click:^(NSString *title) {
        
    }];
}

#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    
}



@end
