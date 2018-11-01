//
//  ForumDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumDetailViewController.h"

#import "ForumDetailTableViewCell.h"
#import "ReadPostListTableViewCell.h"

@interface ForumDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ForumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView];
    
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    UIBarButtonItem *searchBtn = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(@"forum_search")];
    
    _attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_attentionBtn setNormalImage:UIImageNamed(@"forum_notAttention")];
    [_attentionBtn setSelectedImage:UIImageNamed(@"forum_attention")];
    _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc]initWithCustomView:_attentionBtn];
    
    self.navigationItem.rightBarButtonItems = @[searchBtn,rightBtn2];
}

-(void)setUI
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
    [_tableView registerClass:[ForumDetailTableViewCell class] forCellReuseIdentifier:ForumDetailTableViewCellID];
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
}

//搜索点击
-(void)searchAction
{
    
}

//关注点击
-(void)attentionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ForumDetailTableViewCell *cell0 = (ForumDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumDetailTableViewCellID];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"type"] = @(indexPath.row);
        dic[@"label"] = @"置顶";
        if (indexPath.row == 0) {
            dic[@"label"] = @"公告";
        }
        [cell0 setData:dic];
        cell = cell0;
    }else
    if (indexPath.section == 1) {
        ReadPostListTableViewCell *cell1 = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"imgs"] = @"0";
        if (indexPath.row == 0) {
            dic[@"ShowChildComment"] = @(1);
        }else if (indexPath.row == 1) {
            dic[@"imgs"] = @"1";
            dic[@"ShowChildComment"] = @(1);
        }else if(indexPath.row == 2){
            dic[@"imgs"] = @"3";
            dic[@"ShowChildComment"] = @(1);
        }
        
        [cell1 setData:dic];
        cell = cell1;
    }
    
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
