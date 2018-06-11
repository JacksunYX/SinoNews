//
//  AttentionRecommendVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/8.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendVC.h"
#import "SearchViewController.h"    //搜索页面
#import "BaseTableView.h"

#import "AttentionRecommendFirstCell.h"
#import "AttentionRecommendSecondCell.h"


@interface AttentionRecommendVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BaseTableView *tableView;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation AttentionRecommendVC

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *title = @[
                           @"军事机密",
                           @"军武次位面",
                           @"测试一下",
                           @"随便啦",
                           @"快科技",
                           ];
        NSArray *img = @[
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         @"user_icon",
                         ];
        NSArray *fansNum = @[
                             @100,
                             @2421,
                             @454,
                             @22,
                             @9,
                             ];
        NSArray *subTitle = @[
                              @"《军武次位面》是知名的网络军事类视频节目，注重调侃娱乐性，但是其在专业深度上也毫不逊色。当有新节目更新时我们提醒你。",
                              @"没错，上知天文，下知地理...",
                              @"你敢动吗？",
                              @"不敢不敢",
                              @"算你识相~",
                              ];
        NSArray *isAttention = @[
                                 @0,
                                 @0,
                                 @1,
                                 @0,
                                 @1,
                                 ];
        for (int i = 0; i < 3; i ++) {
            NSMutableArray *dataArr = [NSMutableArray new];
            for (int j = 0; j < title.count; j ++) {
                AttentionRecommendModel *model = [AttentionRecommendModel new];
                model.title = title[arc4random()%title.count];
                model.img = img[arc4random()%img.count];
                model.fansNum = [fansNum[arc4random()%fansNum.count] integerValue];
                model.subTitle = subTitle[arc4random()%subTitle.count];
                model.isAttention = isAttention[arc4random()%isAttention.count];
                [dataArr addObject:model];
            }
            [_dataSource addObject:dataArr];
        }
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐";
    self.view.backgroundColor = WhiteColor;
    [self addNavigationView];
    
    [self addTableview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(searchAction) image:@"attention_search" hightimage:nil andTitle:@""];
    
}

-(void)searchAction
{
    SearchViewController *sVC = [SearchViewController new];
    [self.navigationController pushViewController:sVC animated:NO];
}

-(void)addTableview
{
    tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - NAVI_HEIGHT - BOTTOM_MARGIN) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.backgroundColor = BACKGROUND_COLOR;
    [tableView registerClass:[AttentionRecommendFirstCell class] forCellReuseIdentifier:AttentionRecommendFirstCellID];
    [tableView registerClass:[AttentionRecommendSecondCell class] forCellReuseIdentifier:AttentionRecommendSecondCellID];
    [self.view addSubview:tableView];
}

#pragma mark --- UITableViewDataSource ---

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        AttentionRecommendFirstCell *cell0 = (AttentionRecommendFirstCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendFirstCellID];
        cell0.dataSource = self.dataSource[indexPath.section];
        WEAK(weakSelf, self);
        cell0.selectedIndex = ^(NSInteger index) {
            [weakSelf choseSection:0 row:index];
        };
        cell = (UITableViewCell *)cell0;
    }else{
        AttentionRecommendSecondCell *cell1 = (AttentionRecommendSecondCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendSecondCellID];
        cell1.dataSource = self.dataSource[indexPath.section];
        WEAK(weakSelf, self);
        cell1.selectedIndex = ^(NSInteger index) {
            [weakSelf choseSection:indexPath.section row:index];
        };
        cell = (UITableViewCell *)cell1;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 1){
        return 205;
    }else if (indexPath.section == 2){
        return 205;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void)choseSection:(NSInteger)section row:(NSInteger)index
{
    GGLog(@"点击了第%ld分区的第个%ldcell",section,index);
}



@end
