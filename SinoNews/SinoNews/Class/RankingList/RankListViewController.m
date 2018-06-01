//
//  RankDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/31.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankListViewController.h"
#import "GroupShadowTableView.h"
#import "RankListTableViewCell.h"
#import "RankDetailViewController.h"

@interface RankListViewController ()<GroupShadowTableViewDelegate,GroupShadowTableViewDataSource>
@property (strong, nonatomic) GroupShadowTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation RankListViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *userIcon = @[
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              @"user_icon",
                              ];
        NSArray *title = @[
                           @"儿童娱乐场",
                           @"成人娱乐场",
                           @"测试娱乐场",
                           @"竞技娱乐场",
                           @"贪玩娱乐场",
                           @"中老年娱乐场",
                           @"猛男娱乐场",
                           @"淑女娱乐场",
                           @"混搭娱乐场",
                           @"血战娱乐场",
                           ];
        NSArray *score = @[
                           @"99.9 分",
                           @"99.5 分",
                           @"99.1 分",
                           @"97.0 分",
                           @"96.5 分",
                           @"94.5 分",
                           @"90.0 分",
                           @"88.5 分",
                           @"85.5 分",
                           @"82.5 分",
                           ];
        
        NSArray *subTitle = @[
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              @"首存送100奖金",
                              ];
        NSArray *upOrDown = @[
                              @1,
                              @1,
                              @1,
                              @0,
                              @0,
                              @0,
                              @1,
                              @0,
                              @1,
                              @0,
                              ];
        for (int i = 0; i < userIcon.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"userIcon"] = userIcon[i];
            dic[@"title"] = title[i];
            dic[@"score"] = score[i];
            dic[@"subTitle"] = subTitle[i];
            dic[@"upOrDown"] = upOrDown[i];
            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"xxx排行榜";
    
    [self addBaseViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addBaseViews
{
    self.tableView = [[GroupShadowTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.groupShadowDelegate = self;
    self.tableView.groupShadowDataSource = self;
    self.tableView.showSeparator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];

    self.tableView.sd_layout
    .leftEqualToView(self.view)
    .topEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    ;
    [self.tableView updateLayout];
    
    [self.tableView registerClass:[RankListTableViewCell class] forCellReuseIdentifier:RankListTableViewCellID];
    
}

//MARK: - GroupShadowTableViewDataSource
- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return 4;
}

- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 3) {
        return 1;
    }
    return 7;
}

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RankListTableViewCell *cell = (RankListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RankListTableViewCellID];
    NSInteger num = 0;
    if (indexPath.section < 3) {
        num = indexPath.section;
    }else{
        num = indexPath.row + 3;
    }
    cell.tag = num + 1;
    cell.model = self.dataSource[num];
    return cell;
    
}

//MARK: - GroupShadowTableViewDelegate
- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 3) {
        return 84;
    }
    return 72;
}

- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RankDetailViewController *rdVC = [RankDetailViewController new];
    [self.navigationController pushViewController:rdVC animated:YES];
}


@end
