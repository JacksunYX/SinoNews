//
//  BrowsingHistoryVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BrowsingHistoryVC.h"
#import "BrowsingHistoryCell.h"

@interface BrowsingHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BrowsingHistoryVC

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        NSArray *sections = @[
                              @"2018年05月25日  星期五",
                              @"2018年05月24日  星期四",
                              @"2018年05月23日  星期三",
                              @"2018年05月22日  星期二",
                              @"2018年05月21日  星期一",
                              ];
        NSArray *newsTitle = @[
                               @"中移动退出国内首款eSIM芯片 未来候机无需在插卡",
                               @"测试一下浏览历史而已",
                               @"别怕别怕，一切都会好的",
                               @"我现在说一声RNG牛逼还有人点赞嘛？",
                               @"别玩抖音了，赶紧去买菜去～",
                               ];
        NSArray *browsTime = @[
                               @"5-25 13:45",
                               @"5-24 10:07",
                               @"5-23 15:22",
                               @"5-22 20:15",
                               @"5-21 08:37",
                               ];
        NSArray *newsAuthor = @[
                                @"张少华",
                                @"刘德华",
                                @"简自豪",
                                @"刘士余",
                                @"是森命",
                                ];
        NSArray *newsImg = @[
                             @"banner0",
                             @"banner1",
                             @"banner2",
                             @"banner3",
                             ];
        for (int i = 0 ; i < 5; i ++) {
            NSMutableDictionary *sectionDic = [NSMutableDictionary new];
            sectionDic[@"sectionTitle"] = sections[i];
            NSMutableArray *models = [NSMutableArray new];
            int k = arc4random()%5;
            for (int j = 0; j < k; j ++) {
                NSDictionary *model = @{
                                        @"newsTitle"    :   newsTitle[arc4random()%newsTitle.count],
                                        @"browsTime"    :   browsTime[arc4random()%browsTime.count],
                                        @"newsAuthor"    :   newsAuthor[arc4random()%newsAuthor.count],
                                        @"newsImg"    :   newsImg[arc4random()%newsImg.count],
                                        
                                        };
                [models addObject:model];
            }
            sectionDic[@"models"] = models;
            [_dataSource addObject:sectionDic];
        }
        
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"浏览历史";
    self.view.backgroundColor = WhiteColor;
    
    [self addNavigationView];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(clearAction) image:nil hightimage:nil andTitle:@"清空"];
}

//添加tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //注册
    [self.tableView registerClass:[BrowsingHistoryCell class] forCellReuseIdentifier:BrowsingHistoryCellID];
}

//清空浏览历史
-(void)clearAction
{
    GGLog(@"浏览历史已情况");
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section][@"models"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowsingHistoryCell *cell = (BrowsingHistoryCell *)[tableView dequeueReusableCellWithIdentifier:BrowsingHistoryCellID];
    NSDictionary *model = self.dataSource[indexPath.section][@"models"][indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource[section][@"models"] count]) {
        return 40;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    if ([self.dataSource[section][@"models"] count]) {
        headView.backgroundColor = HexColor(#f6f6f6);
        UILabel *title = [UILabel new];
        title.font = Font(14);
        
        [headView addSubview:title];
        title.sd_layout
        .leftSpaceToView(headView, 10)
        .centerYEqualToView(headView)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        [title setMaxNumberOfLinesToShow:1];
        
        title.text = GetSaveString(self.dataSource[section][@"sectionTitle"]);
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




@end
