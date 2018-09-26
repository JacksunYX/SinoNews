//
//  PraiseViewController.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//
//

#import "MessagePraiseViewController.h"
#import "PraiseTableViewCell.h"

@interface MessagePraiseViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation MessagePraiseViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *comment = @[
                             @"我说一句RNG🐂🍺还有人赞嘛？",
                             @"来一场精彩绝伦的比赛吧！",
                             @"我不能进去吗？",
                             @"福无双至，祸不单行～",
                             @"无形之刃，最为致命～",
                             @"让我抱抱你吧～",
                             ];
        NSArray *time = @[
                          @"3小时前",
                          @"1小时前",
                          @"10分钟前",
                          @"1天前",
                          @"5天前",
                          @"13分钟前",
                          ];
        
        NSArray *name = @[
                          @"uzi",
                          @"xiaohu",
                          @"letme",
                          @"ming",
                          @"mlxg",
                          @"karsa",
                          ];
        NSArray *icon = @[
                          @"userIcon",
                          @"user_icon",
                          @"userIcon",
                          @"user_icon",
                          @"userIcon",
                          @"user_icon",
                          ];
        
        for (int i = 0; i < 10; i ++) {
            NSMutableDictionary *model = [NSMutableDictionary new];
            model[@"comment"] = comment[arc4random()%comment.count];
            model[@"time"] = time[arc4random()%time.count];
            NSMutableArray *praises = [NSMutableArray new];
            NSInteger num = arc4random()%6 + 1;
            for (int j = 0; j < num; j ++) {
                NSDictionary *dic = @{
                                      @"name"   :   name[arc4random()%name.count],
                                      @"icon"   :   icon[arc4random()%icon.count],
                                      };
                [praises addObject:dic];
            }
            model[@"praises"] = praises;
//            [_dataSource addObject:model];
        }
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"赞";
    [self showTopLine];
    [self addTableView];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noPraise" title:@"暂无人点赞"];
    
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
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //注册
    [self.tableView registerClass:[PraiseTableViewCell class] forCellReuseIdentifier:PraiseTableViewCellID];
    
    @weakify(self)
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.tableView ly_startLoading];
        [self requestGetPraiseHistory];
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
    PraiseTableViewCell *cell = (PraiseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PraiseTableViewCellID];
    cell.model = self.dataSource[indexPath.row];
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 88;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark ----- 请求发送
//获取点赞记录
-(void)requestGetPraiseHistory
{
    
    [HttpRequest postWithURLString:GetPraiseHistory parameters:nil isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        self.dataSource = [PraiseHistoryModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
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
