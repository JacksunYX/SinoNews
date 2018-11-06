//
//  RemindOthersToReadViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "RemindOthersToReadViewController.h"

@interface RemindOthersToReadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation RemindOthersToReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI
{
    UIButton *confirmBtn = [UIButton new];
    confirmBtn.backgroundColor = HexColor(#A1C5E5);
    [confirmBtn setNormalTitleColor:WhiteColor];
    [confirmBtn setBtnFont:PFFontL(16)];
    [self.view addSubview:confirmBtn];
    confirmBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN)
    .heightIs(46)
    ;
    [confirmBtn setNormalTitle:@"确定"];
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(confirmBtn, 0)
    ;
    
    [_tableView registerClass:[RemindSelectTableViewCell class] forCellReuseIdentifier:RemindSelectTableViewCellID];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindSelectTableViewCell *cell = (RemindSelectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RemindSelectTableViewCellID];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGLog(@"点击了搜索列表的cell");
}

@end
