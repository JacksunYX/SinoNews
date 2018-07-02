//
//  MyFansViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyFansViewController.h"

@interface MyFansViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MyFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"粉丝";
    self.view.backgroundColor = WhiteColor;
    [self addTableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addTableview
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.bottom_attr;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    self.tableView.backgroundColor = WhiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = RGBA(227, 227, 227, 1);
}



@end
