//
//  NotifyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NotifyViewController.h"

@interface NotifyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation NotifyViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *title = @[
                           @"我说一句RNG🐂🍺还有人赞嘛？",
                           @"来一场精彩绝伦的比赛吧！",
                           @"我不能进去吗？",
                           @"福无双至，祸不单行～",
                           @"无形之刃，最为致命～",
                           @"让我抱抱你吧～",
                           ];
        NSArray *subTitle = @[
                              @"uzi",
                              @"xiaohu",
                              @"letme",
                              @"ming",
                              @"mlxg",
                              @"karsa",
                              ];
        for (int i = 0; i < 10; i ++) {
            NSDictionary *dic = @{
                                  @"title"  :   title[arc4random()%title.count],
                                  @"subTitle"  :   subTitle[arc4random()%subTitle.count],
                                  };
            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知";
    self.view.backgroundColor = WhiteColor;
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:3 reuseIdentifier:@"NotifyCell"];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        cell.detailTextLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        cell.detailTextLabel.textColor = RGBA(152, 152, 152, 1);
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.dataSource[indexPath.row][@"subTitle"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}






@end
