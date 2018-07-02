//
//  NotifyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MessageNotifyViewController.h"

@interface MessageNotifyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MessageNotifyViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *title = @[
                           @"写梦一场您好，您已成功充值1000积分",
                           @"您收藏的猜大小娱乐场有新的优惠，敬请关注",
                           @"写梦一场您好，您已成功充值1000积分",
                           @"您收藏的猜大小娱乐场有新的优惠，敬请关注",
                           @"写梦一场您好，您已成功充值1000积分",
                           @"您收藏的猜大小娱乐场有新的优惠，敬请关注",
                           ];
        NSArray *subTitle = @[
                              @"18-06-04 16:45",
                              @"18-05-28 06:12",
                              @"18-06-01 17:23",
                              @"18-03-04 10:30",
                              @"18-05-20 05:20",
                              @"18-04-28 22:00",
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
        cell.textLabel.font = PFFontL(16);
        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        cell.detailTextLabel.font = PFFontL(12);
        cell.detailTextLabel.textColor = RGBA(152, 152, 152, 1);
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    cell.detailTextLabel.text = self.dataSource[indexPath.row][@"subTitle"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
