//
//  MessageSystemNoticeViewController.m
//  SinoNews
//
//  Created by Michael on 2019/2/25.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "MessageSystemNoticeViewController.h"

#import "MessageSystemNoticeTableViewCell.h"

@interface MessageSystemNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation MessageSystemNoticeViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *title = @[
                           @"【最后30天】即刻注册IHG先行者活动，赚享双倍积 分及启世录独享积分大礼",
                           @"测试一下",
                           ];
        NSArray *time = @[
                          @"11-14",
                          @"02-25",
                          ];
        for (int i = 0; i < title.count; i ++) {
            NSMutableDictionary *model = [NSMutableDictionary new];
            model[@"title"] = title[i];
            model[@"time"] = time[i];
            [_dataSource addObject:model];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统消息";
    [self addTableView];
}

//添加tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = HexColor(#E3E3E3);
    //注册
    [self.tableView registerClass:[MessageSystemNoticeTableViewCell class] forCellReuseIdentifier:MessageSystemNoticeTableViewCellID];
    
//    @weakify(self)
//    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self.tableView ly_startLoading];
//
//    }];
//    [self.tableView.mj_header beginRefreshing];
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
    MessageSystemNoticeTableViewCell *cell = (MessageSystemNoticeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MessageSystemNoticeTableViewCellID];
    cell.model = self.dataSource[indexPath.row];
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
