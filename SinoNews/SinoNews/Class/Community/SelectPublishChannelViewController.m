//
//  SelectPublishChannelViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectPublishChannelViewController.h"

#import "ForumLeftTableViewCell.h"
#import "SelectPublishChannelCell.h"

@interface SelectPublishChannelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *centerTable;
@property (nonatomic,strong) BaseTableView *rightTable;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@property (nonatomic,assign) NSInteger centerSelectedIndex;
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) UIButton *publishBtn;

@end

@implementation SelectPublishChannelViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *leftArr = @[
                             @"我的关注",
                             @"酒店常客",
                             @"航空常客",
                             @"信用卡",
                             @"飞科生活",
                             ];
        NSArray *centerArr = @[
                               @"酒店Report",
                               @"IHG优悦会",
                               @"万豪礼赏",
                               @"spg俱乐部",
                               @"希尔顿荣誉客会",
                               ];
        NSArray *rightArr = @[
                              @"洲际",
                              @"喜达屋",
                              @"雅高",
                              @"万豪",
                              @"凯悦",
                              ];
        
        [_dataSource addObject:leftArr];
        [_dataSource addObject:centerArr];
        [_dataSource addObject:rightArr];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationView];
    [self setUI];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [_centerTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.title = @"选择发表到的版块";
    [self setTopLineColor:HexColor(#E3E3E3)];
    
    _publishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_publishBtn setNormalTitle:@"发表"];
    [_publishBtn setNormalTitleColor:HexColor(#161A24)];
    
    [_publishBtn setBtnFont:PFFontR(16)];
    [_publishBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_publishBtn];
}

-(void)publishAction:(UIButton *)sender
{
    LRToast(@"发表中...");
    if (_sectionId) {
        [self requestPublishPost];
    }
}

-(void)setUI
{
    CGFloat avgW = ScreenW *(1.0/3);
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTable.backgroundColor = HexColor(#EEEEEE);
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTable.separatorColor = CutLineColor;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    
    _centerTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _centerTable.backgroundColor = WhiteColor;
    _centerTable.delegate = self;
    _centerTable.dataSource = self;
    _centerTable.showsVerticalScrollIndicator = NO;
    _centerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_centerTable];
    _centerTable.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(_leftTable, 0)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_centerTable updateLayout];
    [_centerTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTable.backgroundColor = WhiteColor;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.showsVerticalScrollIndicator = NO;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    _rightTable.sd_layout
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .widthIs(avgW)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[SelectPublishChannelCell class] forCellReuseIdentifier:SelectPublishChannelCellID];
    
}

#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        NSMutableArray *arr1 = self.dataSource[0];
        return arr1.count;
    }
    if (tableView == _centerTable) {
        NSMutableArray *arr2 = self.dataSource[1];
        return arr2.count;
    }
    if (tableView == _rightTable) {
        NSMutableArray *arr3 = self.dataSource[2];
        return arr3.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell0 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        NSMutableArray *arr1 = self.dataSource[0];
        NSString *title = arr1[indexPath.row];
        [cell0 setTitle:title];
        cell = cell0;
    }else if (tableView == _centerTable) {
        SelectPublishChannelCell *cell1 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        cell1.type = 1;
        NSMutableArray *arr2 = self.dataSource[1];
        NSString *title = arr2[indexPath.row];
        [cell1 setTitle:title];
        cell = cell1;
    }else if (tableView == _rightTable) {
        SelectPublishChannelCell *cell2 = (SelectPublishChannelCell *)[tableView dequeueReusableCellWithIdentifier:SelectPublishChannelCellID];
        NSMutableArray *arr3 = self.dataSource[2];
        NSString *title = arr3[indexPath.row];
        [cell2 setTitle:title];
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_leftTable.frame.size.width tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _leftTable) {
        if (self.leftSelectedIndex == indexPath.row) {
            return;
        }
        self.leftSelectedIndex = indexPath.row;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_centerTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if (tableView == _centerTable){NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_rightTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
}

#pragma mark --请求
//发表帖子
-(void)requestPublishPost
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    [HttpRequest postWithURLString:PublishPost parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        
    } failure:nil RefreshAction:nil];
}

@end
