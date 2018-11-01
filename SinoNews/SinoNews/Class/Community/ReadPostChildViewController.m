//
//  ReadPostChildViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadPostChildViewController.h"

#import "ReadPostListTableViewCell.h"

@interface ReadPostChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *topBtnArr;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ReadPostChildViewController
-(NSMutableArray *)topBtnArr
{
    if (!_topBtnArr) {
        _topBtnArr = [NSMutableArray new];
    }
    return _topBtnArr;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addTopView];
    [self setUpTableView];
}

-(void)addTopView
{
    _topView = [UIView new];
    _topView.backgroundColor = WhiteColor;
    [self.view addSubview:_topView];
    _topView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(40)
    ;
    [_topView updateLayout];
    
    NSArray *titleArr = @[
                          @"发帖时间",
                          @"回复时间",
                          @"最新热门",
                          @"最新好文",
                          ];
    CGFloat wid = ScreenW/4;
    CGFloat hei = _topView.height;
    for (int i = 0; i <4; i ++) {
        UIButton *btn = [UIButton new];
        btn.tag = 100+i;
        [btn setBtnFont:PFFontM(12)];
        [btn setNormalTitleColor:LightGrayColor];
        [btn setSelectedTitleColor:HexColor(#1282ee)];
        [_topView addSubview:btn];
        [self.topBtnArr addObject:btn];
        btn.sd_layout
        .leftSpaceToView(_topView, wid*i)
        .topEqualToView(_topView)
        .widthIs(wid)
        .heightIs(hei)
        ;
        [btn setNormalTitle:titleArr[i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self selectIndex:0];
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
//    _tableView.sd_layout
//    .topSpaceToView(self.topView, 0)
//    .leftEqualToView(self.view)
//    .rightEqualToView(self.view)
//    .bottomEqualToView(self.view)
//    ;
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.topView.bottom_attr;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [_tableView updateLayout];
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
}

//按钮点击事件
-(void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    [self selectIndex:index];
}

//选择制定下标的按钮选中，其他按钮不选中
-(void)selectIndex:(NSInteger)selected
{
    UIButton *selectedBtn = self.topBtnArr[selected];
    if (selectedBtn.selected) {
        return;
    }else{
        selectedBtn.selected = !selectedBtn.selected;
        GGLog(@"选中了下标为%ld的按钮",selected);
        
    }
    for (int i = 0; i <self.topBtnArr.count; i ++) {
        if (i != selected) {
            UIButton *otherBtn = self.topBtnArr[i];
            otherBtn.selected = NO;
        }
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadPostListTableViewCell *cell = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
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
    
    [cell setData:dic];
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
