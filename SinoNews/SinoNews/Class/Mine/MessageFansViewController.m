//
//  MessageFansViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MessageFansViewController.h"
#import "UserInfoViewController.h"
#import "FansTableViewCell.h"

@interface MessageFansViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MessageFansViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *name = @[
                          @"uzi",
                          @"xiaohu",
                          @"letme",
                          @"ming",
                          @"mlxg",
                          @"karsa",
                          ];
        NSArray *time = @[
                          @"3小时前",
                          @"1小时前",
                          @"10分钟前",
                          @"1天前",
                          @"5天前",
                          @"13分钟前",
                          ];
        NSArray *icon = @[
                          @"userIcon",
                          @"user_icon",
                          @"userIcon",
                          @"user_icon",
                          @"userIcon",
                          @"user_icon",
                          ];
        NSArray *sex = @[
                         @0,
                         @1,
                         @0,
                         @2,
                         @0,
                         @1,
                         ];
        for (int i = 0; i < 6; i ++) {
            NSDictionary *dic = @{
                                  @"name"   :   name[arc4random()%name.count],
                                  @"time"   :   time[arc4random()%time.count],
                                  @"icon"   :   icon[arc4random()%icon.count],
                                  @"sex"   :   sex[arc4random()%sex.count],
                                  
                                  };
//            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的粉丝";
    [self showTopLine];
    [self addTableView];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noFans" title:@"暂无粉丝关注你"];
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
//    [self.tableView addBakcgroundColorTheme];
    
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(BaseTableView *)item setBackgroundColor:HexColor(#292d30)];
            [(BaseTableView *)item setSeparatorColor:CutLineColorNight];
        }else{
            [(BaseTableView *)item setBackgroundColor:HexColor(#F2F6F7)];
            [(BaseTableView *)item setSeparatorColor:CutLineColor];
        }
    });
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //注册
    [self.tableView registerClass:[FansTableViewCell class] forCellReuseIdentifier:FansTableViewCellID];
    @weakify(self)
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView ly_startLoading];
        [self requestGetFansHistory];
    }];
    [self.tableView.mj_header beginRefreshing];
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
    FansTableViewCell *cell = (FansTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FansTableViewCellID];
    cell.model = self.dataSource[indexPath.row];
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
    MyFansModel *model = self.dataSource[indexPath.row];
    UserInfoViewController *uiVC = [UserInfoViewController new];
    uiVC.userId = model.userId;
    [self.navigationController pushViewController:uiVC animated:YES];
}

#pragma mark ----- 请求发送
//获取粉丝关注记录
-(void)requestGetFansHistory
{
    
    [HttpRequest postWithURLString:GetFansHistory parameters:nil isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.dataSource = [MyFansModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *erro) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } RefreshAction:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
