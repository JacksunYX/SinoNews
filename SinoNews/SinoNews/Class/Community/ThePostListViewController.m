//
//  ThePostListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostListViewController.h"

#import "ThePostListTableViewCell.h"

@interface ThePostListViewController ()<UITableViewDelegate,UITableViewDataSource,TFDropDownMenuViewDelegate>
@property (nonatomic,strong) TFDropDownMenuView *menu;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ThePostListViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

-(void)setUI
{
    [self setUpMenu];
    [self setUpTableView];
}

-(void)setUpTableView
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(self.menu, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[ThePostListTableViewCell class] forCellReuseIdentifier:ThePostListTableViewCellID];
}

//设置下拉菜单
-(void)setUpMenu
{
    NSMutableArray *array1 = @[
                               @"所有版块",
                               @"招商银行",
                               @"民生银行",
                               @"国内信用卡",
                               @"工商银行",
                               @"工浦发银行",
                               @"机场贵宾服务",
                               @"万豪礼赏",
                               @"二手市集",
                               @"spg俱乐部",
                               ].mutableCopy;
    NSMutableArray *array2 = @[
                               @"最新发帖",
                               @"回帖最多",
                               @"收藏最多",
                               ].mutableCopy;
    NSMutableArray *data1 = @[array1, array2].mutableCopy;
    //哪怕没有二级菜单也要这么写，不然就没有默认选项
    NSMutableArray *data2 = @[@[], @[]].mutableCopy;
    self.menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 34) firstArray:data1 secondArray:data2];
    self.menu.delegate = self;
    self.menu.cellSelectBackgroundColor = WhiteColor;
    self.menu.separatorColor = WhiteColor;
    self.menu.itemTextSelectColor = HexColor(#1282ee);
    self.menu.cellTextSelectColor = HexColor(#1282ee);
    self.menu.tableViewHeight = 170;
    self.menu.cellHeight = 50;
    self.menu.itemFontSize = 15;
    self.menu.cellTitleFontSize = 15;
    [self.view addSubview:self.menu];
    //副标题
    NSMutableArray *detail1 = @[
                                @"12",
                                @"15",
                                @"33",
                                @"12",
                                @"55",
                                @"34",
                                @"18",
                                @"62",
                                @"33",
                                @"99",
                                ].mutableCopy;
    NSMutableArray *detail2 = @[].mutableCopy;
    self.menu.firstRightArray = @[detail1, detail2].mutableCopy;
    self.menu.menuStyleArray = @[
                                 [NSNumber numberWithInteger:TFDropDownMenuStyleCollectionView],
                                 [NSNumber numberWithInteger:TFDropDownMenuStyleTableView]
                                 ].mutableCopy;
}

-(void)hiddenMenu
{
    [self.menu hiddenMenu];
}

#pragma mark --- TFDropDownMenuViewDelegate ---
//点击了第几个item
- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column {
    GGLog(@"column: %ld", column);
}
//点击了第几行cell
- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index {
    GGLog(@"index: %ld", (long)index.section);
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThePostListTableViewCell *cell = (ThePostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ThePostListTableViewCellID];
    [cell setData:@{}];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
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
