//
//  BrowsingHistoryVC.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BrowsingHistoryVC.h"
#import "BrowsingHistoryCell.h"
#import "HomePageFirstKindCell.h"
#import "HomePageFourthCell.h"
#import "NewsDetailViewController.h"

@interface BrowsingHistoryVC ()<UITableViewDataSource,UITableViewDelegate,MLMSegmentHeadDelegate>
{
    NSInteger selectedIndex;    //选择的下标
}
@property (nonatomic,strong) MLMSegmentHead *segHead;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *newsArr;
@property (nonatomic,strong) NSMutableArray *postsArr;
@end

@implementation BrowsingHistoryVC

-(NSMutableArray *)newsArr
{
    if (!_newsArr) {
        _newsArr = [NSMutableArray new];
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
                               @"别玩抖音了，赶紧去买菜去",
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
//            [_newsArr addObject:sectionDic];
        }
        
    }
    return _newsArr;
}

-(NSMutableArray *)postsArr
{
    if (!_postsArr) {
        _postsArr = [NSMutableArray new];
    }
    return _postsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"浏览历史";
    
    [self setTitleView];
    
    [self addNavigationView];
    
    [self addTableView];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noHistory" title:@"暂无任何历史记录"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView ly_startLoading];
    self.newsArr = [[HomePageModel getSortedHistory] mutableCopy];
    self.postsArr = [[HomePageModel getSortedHistory] mutableCopy];
    [self.tableView reloadData];
    [self.tableView ly_endLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(clearAction) image:nil hightimage:nil andTitle:@"清空"];
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(clearAction) title:@"清空"];
}

-(void)setTitleView
{
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, 200, 44) titles:@[@"新闻",@"帖子"] headStyle:0 layoutStyle:0];
    //    _segHead.fontScale = .85;
    //    _segHead.lineScale = 0.6;
    _segHead.fontSize = 16;
    //    _segHead.lineHeight = 3;
    //    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = RGBA(50, 50, 50, 1);
    _segHead.deSelectColor = RGBA(152, 152, 152, 1);
    _segHead.maxTitles = 2;
    _segHead.bottomLineHeight = 0;
    _segHead.bottomLineColor = RGBA(227, 227, 227, 1);
    _segHead.delegate = self;
    @weakify(self)
    [MLMSegmentManager associateHead:_segHead withScroll:nil completion:^{
        @strongify(self)
        self.navigationItem.titleView = self.segHead;
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
    });
}

//添加tableview
-(void)addTableView
{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    @weakify(self)
    [self.tableView activateConstraints:^{
        @strongify(self)
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [self.tableView addBakcgroundColorTheme];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //注册
    [self.tableView registerClass:[BrowsingHistoryCell class] forCellReuseIdentifier:BrowsingHistoryCellID];
    [self.tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    [self.tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
}

//清空浏览历史
-(void)clearAction
{
    if (!self.newsArr.count&&selectedIndex == 0) {
        LRToast(@"没有可以清空的历史哦");
        return;
    }else if (!self.postsArr.count&&selectedIndex == 1){
        LRToast(@"没有可以清空的历史哦");
        return;
    }
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"清空浏览历史？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HomePageModel clearLocaHistory];
        LRToast(@"已清空浏览历史");
        GCDAfterTime(1, ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:confirm];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ----- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (selectedIndex==0) {
        return self.newsArr.count;
    }
    return self.postsArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex==0) {
        NSArray *arr = self.newsArr[section];
        return arr.count;
    }
    NSArray *arr = self.postsArr[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id model;
    if (selectedIndex == 0) {
        model = self.newsArr[indexPath.section][indexPath.row];
    }else{
        model = self.postsArr[indexPath.section][indexPath.row];
    }
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = (HomePageModel *)model;
        //暂时只分2种
        if (model1.itemType == 100) {//无图
            HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
            cell1.model = model1;
            cell = (UITableViewCell *)cell1;
        }else{//1图
            HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
            cell1.model = model1;
            cell = (UITableViewCell *)cell1;
        }
    }
    
    [cell addBakcgroundColorTheme];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.newsArr[section] count]&&selectedIndex==0) {
        return 40;
    }else if ([self.postsArr[section] count]&&selectedIndex==1) {
        return 40;
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView;
    if (([self.newsArr[section] count]&&selectedIndex==0)||([self.postsArr[section] count]&&selectedIndex==1)) {
        headView = [UIView new];
        
        headView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            if (UserGetBool(@"NightMode")) {
                [(UIView *)item setBackgroundColor:HexColor(#292D30)];
            }else{
                [(UIView *)item setBackgroundColor:HexColor(#f6f6f6)];
            }
        });
        UILabel *title = [UILabel new];
        title.font = PFFontL(14);
        [title addTitleColorTheme];
        
        [headView addSubview:title];
        title.sd_layout
        .leftSpaceToView(headView, 10)
        .centerYEqualToView(headView)
        .rightSpaceToView(headView, 10)
        .autoHeightRatio(0)
        ;
        [title setMaxNumberOfLinesToShow:1];
        HomePageModel *model;
        if (selectedIndex==0) {
            model = [self.newsArr[section] firstObject];
        }else if (selectedIndex==1) {
            model = [self.postsArr[section] firstObject];
        }
        NSString *sectionTitle = [NSString getDateStringWithTimeStr:model.saveTimeStr];
        title.text = GetSaveString(sectionTitle);
        
    }
    
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model;
    if (selectedIndex == 0) {
        model = self.newsArr[indexPath.section][indexPath.row];
    }else if (selectedIndex==1) {
        model = self.postsArr[indexPath.section][indexPath.row];
    }
    
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = (HomePageModel *)model;
        //获取当前时间戳字符串作为存储时的标记
        model1.saveTimeStr = [NSString currentTimeStr];
        NewsDetailViewController *ndVC = [NewsDetailViewController new];
        ndVC.newsId = model1.itemId;
        [self.navigationController pushViewController:ndVC animated:YES];
    }
}

#pragma mark ---- MLMSegmentHeadDelegate
- (void)didSelectedIndex:(NSInteger)index
{
    selectedIndex = index;
    [self.tableView ly_startLoading];
    [self.tableView reloadData];
    [self.tableView ly_endLoading];
}


@end
