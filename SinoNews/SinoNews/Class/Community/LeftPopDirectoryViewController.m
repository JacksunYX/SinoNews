//
//  LeftPopDirectoryViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "LeftPopDirectoryViewController.h"

#import "DirectoryTableViewCell.h"

@interface LeftPopDirectoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
//只用来保存目录的数组
@property (nonatomic,strong) NSMutableArray *directoryArr;
@end

@implementation LeftPopDirectoryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setUI];
}

-(void)setUI
{
    UILabel *topLabel = [UILabel new];
    UIView *line = [UIView new];
    [self.view sd_addSubviews:@[
                                line,
                                topLabel,
                                ]];
    line.sd_layout
    .topSpaceToView(self.view, NAVI_HEIGHT)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(1)
    ;
    line.backgroundColor = HexColor(#E3E3E3);
    
    topLabel.sd_layout
    .leftSpaceToView(self.view, 10)
    .bottomSpaceToView(line, 14)
    .heightIs(18)
    ;
    [topLabel setSingleLineAutoResizeWithMaxWidth:100];
    topLabel.font = PFFontR(18);
    topLabel.textColor = HexColor(#161A24);
    topLabel.text = @"目录";
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[DirectoryTableViewCell class] forCellReuseIdentifier:DirectoryTableViewCellID];
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    
    _dataSource = dataSource;
    _directoryArr = [NSMutableArray new];
    
    for (int i = 0; i < dataSource.count; i ++) {
        SeniorPostingAddElementModel *model = dataSource[i];
        if (model.addType == 0) {//标题
            [_directoryArr addObject:model];
        }else{
            continue;
        }
    }
    [self.tableView reloadData];
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _directoryArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryTableViewCell *cell = (DirectoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:DirectoryTableViewCellID];
    SeniorPostingAddElementModel *model = self.directoryArr[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeniorPostingAddElementModel *model = self.directoryArr[indexPath.row];
    for (int i = 0; i < self.dataSource.count; i ++) {
        SeniorPostingAddElementModel *model1 = self.dataSource[i];
        if (model1.addType==0) {
            if (model.sectionNum == model1.sectionNum) {
                if (self.clickBlock) {
                    self.clickBlock(i);
                }
                [self hide];
            }
        }else{
            continue;
        }
    }
}


@end
