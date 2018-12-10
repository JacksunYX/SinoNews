//
//  ToReportViewController.m
//  SinoNews
//
//  Created by Michael on 2018/12/10.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ToReportViewController.h"

#import "ToReportTableViewCell.h"

@interface ToReportViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
//标记上一次选择的cell
@property (nonatomic,strong) NSIndexPath *lastIndex;
@end

@implementation ToReportViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"举报原因";
    [self addNavigationView];
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    [self setTopLineColor:HexColor(#E3E3E3)];
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [submitBtn setNormalTitle:@"提交"];
    [submitBtn setNormalTitleColor:HexColor(#161A24)];
    
    [submitBtn setBtnFont:PFFontL(16)];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
}

- (void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = WhiteColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColorNight;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0 ))
    ;
    [_tableView updateLayout];
    [_tableView registerClass:[ToReportTableViewCell class] forCellReuseIdentifier:ToReportTableViewCellID];
    //设置可选
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    
    GCDAfterTime(1, ^{
        self.tableView.editing = YES;
        //这里设置编辑状态后，必须要刷新，不然自定义的选择图标不会马上显示出来
        [self.tableView reloadData];
    });
}

//提交操作
-(void)submitAction
{
    if (!_lastIndex) {
        LRToast(@"请选择举报原因");
    }else{
        [self requestReportThePost];
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
//    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ToReportTableViewCellID];
    cell.textLabel.font = PFFontL(15);
    cell.textLabel.textColor = HexColor(#161A24);
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld条举报原因",indexPath.row];
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lastIndex) {
        //将上个cell取消选中
        [_tableView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:_lastIndex afterDelay:.0];
    }
    //记录此次点击的cell
    _lastIndex = indexPath;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_lastIndex==indexPath) {
        _lastIndex = nil;
    }
}

//举报帖子
-(void)requestReportThePost
{
    
}

@end
