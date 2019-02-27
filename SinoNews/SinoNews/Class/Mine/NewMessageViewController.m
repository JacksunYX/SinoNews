//
//  NewMessageViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/21.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "NewMessageViewController.h"

#import "ReplyListViewController.h"
#import "MessageFansViewController.h"
#import "MessagePraiseViewController.h"
#import "MessageSystemNoticeViewController.h"

@interface NewMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation NewMessageViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *leftTitle = @[
                               @"回复和@我的",
                               @"关注我的",
                               @"给我点赞",
//                               @"系统消息",
                               ];
        NSArray *leftIcon = @[
                              @"message_reply",
                              @"message_attention",
                              @"message_praise",
//                              @"message_systemNotice",
                              ];
        
        for (int i = 0; i < leftTitle.count; i ++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"leftTitle"] = leftTitle[i];
            dic[@"leftIcon"] = leftIcon[i];
            [_dataSource addObject:dic];
        }
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = 1;
        cell.textLabel.font = PFFontL(14);
        cell.textLabel.textColor = HexColor(#161A24);
    }
    [cell.imageView clearBadge];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.imageView.image = UIImageNamed(dic[@"leftIcon"]);
    cell.textLabel.text = GetSaveString(dic[@"leftTitle"]);

    if ((self.tipsModel.hasReply&&indexPath.row == 0)||(self.tipsModel.hasFans&&indexPath.row == 1)||(self.tipsModel.hasPraise&&indexPath.row == 2)) {
        [cell.imageView showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeNone];
        cell.imageView.badgeFrame = CGRectMake(26, -2, 7, 7);
        cell.imageView.badgeBgColor = HexColor(#FF3823);
    }

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
    if (indexPath.row == 0) {
        self.tipsModel.hasReply = NO;
        ReplyListViewController *rlVC = [ReplyListViewController new];
        [self.navigationController pushViewController:rlVC animated:YES];
    }else if (indexPath.row == 1) {
        self.tipsModel.hasFans = NO;
        MessageFansViewController *fvc = [MessageFansViewController new];
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (indexPath.row == 2){
        self.tipsModel.hasPraise = NO;
        MessagePraiseViewController *pvc = [MessagePraiseViewController new];
        [self.navigationController pushViewController:pvc animated:YES];
    }else if (indexPath.row == 3){
        MessageSystemNoticeViewController *nVC = [MessageSystemNoticeViewController new];
        [self.navigationController pushViewController:nVC animated:YES];
    }
    [self.tableView reloadData];
}




@end
