//
//  PostingListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PostingListViewController.h"

#import "ThePostListTableViewCell.h"

@interface PostingListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation PostingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title = @"";
    NSString *notice = @"";
    if (self.type == 0) {
        title = @"我的帖子";
        notice = @"暂无帖子";
    }else
        if (self.type == 1) {
            title = @"我的草稿";
            notice = @"暂无草稿";
        }
    self.navigationItem.title = title;
    
    [self setUI];
}

-(void)setUI
{
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
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [_tableView registerClass:[ThePostListTableViewCell class] forCellReuseIdentifier:ThePostListTableViewCellID];
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
