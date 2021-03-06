//
//  NewNotifyViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NewNotifyViewController.h"
#import "OfficialNotifyViewController.h"

@interface NewNotifyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@end

@implementation NewNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"站内信";
    [self showTopLine];
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 75, 0, 10);
    
    /*
    @weakify(self)
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        self.page = 1;
        
    }];
    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        if (self.dataSource.count>0) {
            self.page++;
        }else{
            self.page = 1;
        }
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    */
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"NotifyCell"];
        cell.textLabel.font = PFFontL(16);
//        cell.textLabel.textColor = RGBA(50, 50, 50, 1);
        [cell.textLabel addTitleColorTheme];
        cell.detailTextLabel.font = PFFontL(13);
//        cell.detailTextLabel.textColor = RGBA(152, 152, 152, 1);
        [cell.detailTextLabel addContentColorTheme];
        
        UIView *accessView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 80, 65)];
        UILabel *time = [UILabel new];
        time.tag = 153;
        time.font = PFFontL(11);
//        time.textColor = RGBA(152, 152, 152, 1);
        [time addContentColorTheme];
        time.textAlignment = NSTextAlignmentCenter;
        [accessView addSubview:time];
        time.sd_layout
        .topSpaceToView(accessView, 15)
        .rightEqualToView(accessView)
        .heightIs(12)
        ;
        [time setSingleLineAutoResizeWithMaxWidth:80];
        cell.accessoryView = accessView;
        
        UIView *sepLine = [UIView new];
//        sepLine.backgroundColor = HexColor(#e3e3e3);
        [sepLine addCutLineColor];
        [cell.contentView addSubview:sepLine];
        sepLine.sd_layout
        .leftSpaceToView(cell.contentView, 75)
        .widthIs(ScreenW - 75)
        .bottomEqualToView(cell.contentView)
        .heightIs(1)
        ;
    }
    cell.imageView.image = UIImageNamed(@"notify_logo");
    cell.textLabel.text = @"启世录官方";
//    cell.detailTextLabel.text = @"你好";
    if (cell.accessoryView) {
        UILabel *time = [cell.accessoryView viewWithTag:153];
//        time.text = @"下午 02:33";
    }
    [cell addBakcgroundColorTheme];
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
    
    OfficialNotifyViewController *onVC = [OfficialNotifyViewController new];
    [self.navigationController pushViewController:onVC animated:YES];
}



@end
