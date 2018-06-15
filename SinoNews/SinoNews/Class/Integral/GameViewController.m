//
//  GameViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "GameViewController.h"
#import "HeadBannerView.h"


@interface GameViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@end

@implementation GameViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
        NSArray *imgs = @[
                          @"gameAd_0",
                          @"gameAd_1",
                          @"gameAd_2",
                          ];
        for (int i = 0; i < 10; i ++) {
            [_dataSource addObject:imgs[arc4random()%imgs.count]];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游戏";
    self.view.backgroundColor = WhiteColor;
    
    [self addTopLoopView];
    
    [self addTableView];
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
        GGLog(@"选择了下标为%ld的轮播图",index);
    };
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        [self.tableView.top_attr equalTo:self.headView.bottom_attr constant:0];
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;

}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *fatherView = cell.contentView;
    if (fatherView.subviews.count) {
        for (UIView *subview in fatherView.subviews) {
            [subview removeFromSuperview];
        }
    }
    [self setSection0WithData:@{@"imgStr":self.dataSource[indexPath.row]} onView:cell];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenH tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了第%ld个",indexPath.row);
}

//设置0区0行内容
-(void)setSection0WithData:(NSDictionary *)model onView:(UITableViewCell *)cell
{
    UIImageView *adView = [UIImageView new];
    
    [cell.contentView addSubview:adView];
    
    CGFloat lrMargin = 10; //左右间距
    adView.sd_layout
    .leftSpaceToView(cell.contentView, lrMargin)
    .rightSpaceToView(cell.contentView, lrMargin)
    .topEqualToView(cell.contentView)
    .heightIs((ScreenW - 2 * lrMargin) * 105 / 355)
    ;
//    [adView setSd_cornerRadius:@6];
    [adView cornerWithRadius:6];
    adView.image = UIImageNamed(GetSaveString(model[@"imgStr"]));
    [cell setupAutoHeightWithBottomView:adView bottomMargin:10];
}

@end
