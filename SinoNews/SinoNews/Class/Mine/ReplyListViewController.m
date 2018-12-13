//
//  ReplyListViewController.m
//  SinoNews
//
//  Created by Michael on 2018/12/3.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReplyListViewController.h"

@interface ReplyListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;
@end

@implementation ReplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复我的";
    
    [self addTableView];
}

//添加tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = HexColor(#EEEEEE);
    [self.view addSubview:_tableView];
    _tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.separatorColor = HexColor(#E3E3E3);
    //注册
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    @weakify(self);
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        self.page = 1;
        [self requestUserListReply];
    }];
    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.dataSource.count>0) {
            self.page ++;
        }else{
            self.page = 1;
        }
        [self requestUserListReply];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = 1;
        cell.textLabel.font = PFFontL(15);
        cell.textLabel.textColor = HexColor(#161A24);
        
        cell.detailTextLabel.font = PFFontL(12);
        cell.detailTextLabel.textColor = HexColor(#9A9A9A);
    }
    NSDictionary *model = self.dataSource[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@回复了你的",model[@"username"]];
    NSInteger type = [model[@"replyType"] integerValue];
    if (type==1) {
        title = [title stringByAppendingString:@"帖子"];
    }else if (type==2){
        title = [title stringByAppendingString:@"评论"];
    }else if (type==3){
        title = [NSString stringWithFormat:@"%@发表了新帖并提醒我查看",model[@"username"]];
    }
    title = [title stringByAppendingString:@",点击查看"];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = GetSaveString(model[@"createTime"]);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
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
    NSDictionary *model = self.dataSource[indexPath.row];
    NSInteger postType = [model[@"postType"] integerValue];
    UIViewController *vc;
    if (postType == 2) { //投票
        TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
        tvpdVC.postModel.postId = [model[@"targetId"] integerValue];
        vc = tvpdVC;
    }else{
        ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
        tpdVC.postModel.postId = [model[@"targetId"] integerValue];
        vc = tpdVC;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --请求
-(void)requestUserListReply
{
    [HttpRequest getWithURLString:UserListReply parameters:@{@"page":@(self.page)} success:^(id responseObject) {
        self.dataSource = [self.tableView pullWithPage:self.page data:responseObject[@"data"][@"data"] dataSource:self.dataSource];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView endAllRefresh];
    }];
}

@end
