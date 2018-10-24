//
//  ForumViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumViewController.h"
#import "ForumLeftTableViewCell.h"
#import "ForumRightTableViewCell.h"

@interface ForumViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *rightTable;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@end

@implementation ForumViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        //虚拟数据
        NSMutableArray *arr1 = @[
                                 @"我的关注",
                                 @"酒店常驻",
                                 @"航空常客",
                                 @"信用卡",
                                 @"飞客生活",
                                 @"网站服务",
                                 ].mutableCopy;
        [_dataSource addObject:arr1];
        
        NSMutableArray *arr2 = [NSMutableArray new];
        
        NSMutableArray *logo = @[
                                 @"share_qq",
                                 @"share_qqZone",
                                 @"share_sina",
                                 @"share_wechat",
                                 @"share_wechatFriend",
                                 ].mutableCopy;
        NSMutableArray *communityName = @[
                                          @"飞行Report",
                                          @"东方航空",
                                          @"中国国航",
                                          @"南方航空",
                                          @"海南航空",
                                          @"吉祥航空",
                                          @"亚洲万里通",
                                          @"星空联盟",
                                          @"寰宇一家",
                                          ].mutableCopy;
        for (int i = 0; i < arr1.count; i ++) {
            NSMutableArray *arr3 = [NSMutableArray new];
            NSInteger arr2Count = arc4random()%10 + 1;
            for (int j = 0; j < arr2Count; j++) {
                NSMutableDictionary *model = [NSMutableDictionary new];
                model[@"logo"] = logo[arc4random()%(logo.count)];
                model[@"communityName"] = communityName[arc4random()%(communityName.count)];
                [arr3 addObject:model];
            }
            [arr2 addObject:arr3];
        }
        
        [_dataSource addObject:arr2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版块";
    
    [self addNavigationView];
    
    [self setUI];
}

//修改导航栏显示
-(void)addNavigationView
{
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        NSString *leftImg = @"return_left";
        NSString *rightImg = @"attention_search";
        if (UserGetBool(@"NightMode")) {
            leftImg = [leftImg stringByAppendingString:@"_night"];
            rightImg = [rightImg stringByAppendingString:@"_night"];
        }
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:leftImg]];
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(rightImg)];
    });
    
}

-(void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)searchAction
{
    GGLog(@"点击了搜索");
}

-(void)setUI
{
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _leftTable.backgroundColor = BACKGROUND_COLOR;
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .widthIs(ScreenW *0.3)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_leftTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _rightTable.backgroundColor = WhiteColor;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    _rightTable.showsVerticalScrollIndicator = NO;
    _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rightTable];
    _rightTable.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(_leftTable, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[ForumRightTableViewCell class] forCellReuseIdentifier:ForumRightTableViewCellID];
    
}

#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        NSMutableArray *arr1 = self.dataSource[0];
        return arr1.count;
    }
    if (tableView == _rightTable) {
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        return arr3.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell1 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        NSMutableArray *arr1 = self.dataSource[0];
        NSString *title = arr1[indexPath.row];
        [cell1 setTitle:title];
        cell = cell1;
    }else if (tableView == _rightTable) {
        ForumRightTableViewCell *cell2 = (ForumRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumRightTableViewCellID];
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        NSDictionary *model = arr3[indexPath.row];
        [cell2 setData:model];
        
        cell = cell2;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_leftTable.frame.size.width tableView:tableView];
    }
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:_rightTable.frame.size.width tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTable) {
        if (arc4random()%2) {
            return 100;
        }
        return 0.01;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head;
    if (tableView == _rightTable) {
        head = [[UIView alloc]initWithFrame: CGRectMake(0, 0, _rightTable.frame.size.width, 100)];
        UIImageView *ADImage = [UIImageView new];
        [head addSubview:ADImage];
        ADImage.sd_layout
        .topSpaceToView(head, 10)
        .leftSpaceToView(head, 10)
        .rightSpaceToView(head, 10)
        .bottomSpaceToView(head, 10)
        ;
        NSString *imageStr = [NSString stringWithFormat:@"gameAd_%d",arc4random()%3];
        ADImage.image = UIImageNamed(imageStr);
        [ADImage whenTap:^{
            GGLog(@"点击了%ld区的广告",(long)self.leftSelectedIndex);
        }];
    }
    
    return head;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        if (self.leftSelectedIndex == indexPath.row) {
            return;
        }
        self.leftSelectedIndex = indexPath.row;
        [_rightTable reloadData];
    }else if (tableView == _rightTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *arr2 = self.dataSource[1];
        NSMutableArray *arr3 = arr2[self.leftSelectedIndex];
        NSDictionary *model = arr3[indexPath.row];
    }
}

@end
