//
//  AttentionRecommendVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/8.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AttentionRecommendVC.h"
#import "SearchViewController.h"    //搜索页面


#import "AttentionRecommendFirstCell.h"
#import "AttentionRecommendSecondCell.h"
#import "AttentionRecommendThirdCell.h"


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
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 @(NO),
                                 ];
        for (int i = 0; i < 3; i ++) {
            NSMutableArray *dataArr = [NSMutableArray new];
            for (int j = 0; j < 15; j ++) {
                AttentionRecommendModel *model = [AttentionRecommendModel new];
                model.title = title[arc4random()%title.count];
                model.img = img[arc4random()%img.count];
                model.fansNum = [fansNum[arc4random()%fansNum.count] integerValue];
                model.subTitle = subTitle[arc4random()%subTitle.count];
                
                model.isAttention = [isAttention[arc4random()%isAttention.count]  boolValue];
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
    [tableView registerClass:[AttentionRecommendFirstCell class] forCellReuseIdentifier:AttentionRecommendFirstCellID];
    [tableView registerClass:[AttentionRecommendSecondCell class] forCellReuseIdentifier:AttentionRecommendSecondCellID];
    [tableView registerClass:[AttentionRecommendThirdCell class] forCellReuseIdentifier:AttentionRecommendThirdCellID];
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
        cell0.attentionIndex = ^(NSInteger row) {
            
            [weakSelf choseAttentionStatusWithSection:indexPath.section line:0 row:row];
        };
        
        cell = (UITableViewCell *)cell0;
    }else if(indexPath.section == 1){
        AttentionRecommendSecondCell *cell1 = (AttentionRecommendSecondCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendSecondCellID];
        cell1.dataSource = self.dataSource[indexPath.section];
        
        WEAK(weakSelf, self);
        cell1.selectedIndex = ^(NSInteger line, NSInteger row) {
            [weakSelf choseSection:indexPath.section line:line row:row];
        };
        
        cell1.attentionBlock = ^(NSInteger line, NSInteger row) {
            
            [weakSelf choseAttentionStatusWithSection:indexPath.section line:line row:row];
        };
        
        cell = (UITableViewCell *)cell1;
    }else if(indexPath.section == 2){
        AttentionRecommendThirdCell *cell2 = (AttentionRecommendThirdCell *)[tableView dequeueReusableCellWithIdentifier:AttentionRecommendThirdCellID];
        cell2.dataSource = self.dataSource[indexPath.section];
        
        WEAK(weakSelf, self);
        cell2.selectedIndex = ^(NSInteger line, NSInteger row) {
            [weakSelf choseSection:indexPath.section line:line row:row];
        };
        
        cell2.attentionBlock = ^(NSInteger line, NSInteger row) {
            
            [weakSelf choseAttentionStatusWithSection:indexPath.section line:line row:row];
        };
        
        cell = (UITableViewCell *)cell2;
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
    if (section != 0) {
        return 43;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    if (section != 0) {
        headView.backgroundColor = BACKGROUND_COLOR;
        UILabel *title = [UILabel new];
        title.font = PFFontL(15);
        
        [headView addSubview:title];
        title.sd_layout
        .leftSpaceToView(headView, 10)
        .bottomSpaceToView(headView, 10)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        [title setMaxNumberOfLinesToShow:1];
        if (section == 1) {
            title.text = @"大咖入驻";
        }else if (section == 2){
            title.text = @"热门频道 ";
        }
    }
    
    return headView;
}

-(void)choseSection:(NSInteger)section row:(NSInteger)index
{
    GGLog(@"点击了第%ld分区的第个%ldcell",section,index);
}

-(void)choseSection:(NSInteger)section line:(NSInteger)line row:(NSInteger)row
{
    GGLog(@"点击了第%ld分区第%ld列的第个%ldcell",section,line,row);
}

//修改对应分区对应cell的关注状态
-(void)choseAttentionStatusWithSection:(NSInteger)section line:(NSInteger)line row:(NSInteger)row
{
    if (section == 0) {
        GGLog(@"改变了分区0的%ld的关注状态",row);
        NSMutableArray *dataSource = [self.dataSource[section] mutableCopy];
        AttentionRecommendModel *model = dataSource[row];
        model.isAttention = !model.isAttention;
        [self.dataSource replaceObjectAtIndex:section withObject:dataSource];
        [tableView reloadData];
        
    }else{
        GGLog(@"改变了分区%ld的%ld列%ld行的关注状态",section,line,row);
        NSMutableArray *dataSource = [self.dataSource[section] mutableCopy];
        NSInteger index = line*3 + row;
        AttentionRecommendModel *model = dataSource[index];
        model.isAttention = !model.isAttention;
        [self.dataSource replaceObjectAtIndex:section withObject:dataSource];
        [tableView reloadData];
    }
}


@end
