//
//  GameViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "GameViewController.h"
#import "HeadBannerView.h"
#import "ADModel.h"

@interface GameViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
//上方的滚动视图
@property (nonatomic, strong) HeadBannerView *headView;
@property (nonatomic,strong) NSMutableArray *adArr; //轮播广告数组
@end

@implementation GameViewController
-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
        NSArray *imgs = @[
                          @"gameAd_0",
                          @"gameAd_1",
                          @"gameAd_2",
                          ];
        for (int i = 0; i < 3; i ++) {
            [_dataSource addObject:imgs[i]];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"游戏";
    
    [self requestBanner];
    
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
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(WIDTH_SCALE * 108)
    ;
    [self.headView updateLayout];
    
    self.headView.type = NormalType;
    self.headView.bottomHeight = 5;
    [self.headView setupUIWithModels:self.adArr];
    
    @weakify(self)
    self.headView.selectBlock = ^(NSInteger index) {
        GGLog(@"选择了下标为%ld的轮播图",index);
        @strongify(self)
        ADModel *model = self.adArr[index];
        [UniversalMethod jumpWithADModel:model];
    };
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        [self.tableView.top_attr equalTo:self.view.top_attr_safe constant:WIDTH_SCALE * 108 + 20];
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [_tableView addBakcgroundColorTheme];
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
    [cell addBakcgroundColorTheme];
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
    LRToast(@"敬请期待");
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
    [adView setSd_cornerRadius:@6];
    adView.image = UIImageNamed(GetSaveString(model[@"imgStr"]));
    [cell setupAutoHeightWithBottomView:adView bottomMargin:10];
}

//请求banner
-(void)requestBanner
{
    [RequestGather requestBannerWithADId:1 success:^(id response) {
        self.adArr = response;
        if (!kArrayIsEmpty(self.adArr)) {
            [self addTopLoopView];
        }
    } failure:nil];
}


@end
