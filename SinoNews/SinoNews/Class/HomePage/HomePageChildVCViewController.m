//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"
#import "BaseTableView.h"
#import "HeadBannerView.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"

#define HeadViewHeight (ScreenW * 9 / 16 + 15)

@interface HomePageChildVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;

@end

@implementation HomePageChildVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testTableView];
    
    [self testBanner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//测试轮播图
-(void)testBanner
{
    if (self.index != 0) {
        return;
    }
    
    HeadBannerView *headView = [HeadBannerView new];
    
    [self.view addSubview:headView];
    
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(HeadViewHeight)
    ;
    [headView updateLayout];
    
    NSMutableArray *imgs = [NSMutableArray new];
    for (int i = 0; i < 4; i ++) {
        NSString *imgStr = [NSString stringWithFormat:@"banner%d",i];
        [imgs addObject:imgStr];
    }
    [headView setupUIWithImageUrls:imgs];
    
    headView.selectBlock = ^(NSInteger index) {
        NSLog(@"选择了下标为%ld的轮播图",index);
    };
    
    self.tableView.tableHeaderView = headView;
}

//测试其他内容
-(void)testTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    ;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册
    [self.tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [self.tableView registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
    [self.tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
        cell = (UITableViewCell *)cell1;
    }
    
    if (indexPath.row == 1) {
        HomePageSecondKindCell *cell2 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
        cell = (UITableViewCell *)cell2;
    }
    
    if (indexPath.row == 2) {
        HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
        cell = (UITableViewCell *)cell3;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return HomePageFirstKindCellH;
    }
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


@end
