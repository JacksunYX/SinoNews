//
//  ReadPostChildViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadPostChildViewController.h"

#import "ReadPostListTableViewCell.h"

@interface ReadPostChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *topBtnArr;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger sortOrder;
@property (nonatomic,assign) NSInteger rate;

@property (nonatomic,assign) NSInteger page;
@end

@implementation ReadPostChildViewController
-(NSMutableArray *)topBtnArr
{
    if (!_topBtnArr) {
        _topBtnArr = [NSMutableArray new];
    }
    return _topBtnArr;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self addTopView];
    [self setUpTableView];
    
    //监听刷新
    @weakify(self);
    [kNotificationCenter addObserverForName:RefreshReadPost object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
    
    //监听关注作者变化
    [kNotificationCenter addObserverForName:AttentionPeopleChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        UIButton *selectedBtn = self.topBtnArr.firstObject;
        [self btnClick:selectedBtn];
    }];
}

-(void)addTopView
{
    _topView = [UIView new];
    _topView.backgroundColor = WhiteColor;
    [self.view addSubview:_topView];
    _topView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(40)
    ;
    [_topView updateLayout];
    [_topView addBorderTo:BorderTypeBottom borderSize:CGSizeMake(ScreenW, 0.3) borderColor:CutLineColor];
    
    NSArray *titleArr = @[
                          @"回复时间",
                          @"发帖时间",
                          @"最新好文",
//                          @"阅读最多",
//                          @"点赞最多",
                          ];
    CGFloat wid = ScreenW/titleArr.count;
    CGFloat hei = _topView.height;
    for (int i = 0; i <titleArr.count; i ++) {
        UIButton *btn = [UIButton new];
        btn.tag = 100+i;
        [btn setBtnFont:PFFontM(12)];
        [btn setNormalTitleColor:LightGrayColor];
        [btn setSelectedTitleColor:HexColor(#1282ee)];
        [_topView addSubview:btn];
        [self.topBtnArr addObject:btn];
        btn.sd_layout
        .leftSpaceToView(_topView, wid*i)
        .topEqualToView(_topView)
        .widthIs(wid)
        .heightIs(hei)
        ;
        [btn setNormalTitle:titleArr[i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self selectIndex:0];
}

-(void)setUpTableView
{
    self.page = 1;
    self.sortOrder = 1;
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = CutLineColor;
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.topView.bottom_attr;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    [self.tableView activateAllConstraints];
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
    
    @weakify(self);
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (CompareString(@"关注版块", self.model.name)) {
            [self requestListUserAttenPost:0];
        }else{
            [self requestListPostForSection:0];
        }
    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (CompareString(@"关注版块", self.model.name)) {
            [self requestListUserAttenPost:1];
        }else{
            [self requestListPostForSection:1];
        }
    }];
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNews" title:@"暂无数据"];
    [self.tableView ly_startLoading];
    
    [_tableView.mj_header beginRefreshing];
}

//按钮点击事件
-(void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    
    _page = 1;
    _rate = 0;
    if (index == 0) {
        _sortOrder = 1;
    }else if (index == 1) {
        _sortOrder = 0;
    }else if (index == 2) {
        _sortOrder = 0;
        _rate = 1;
    }
    
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
    [self selectIndex:index];
}

//选择指定下标的按钮选中，其他按钮不选中
-(void)selectIndex:(NSInteger)selected
{
    UIButton *selectedBtn = self.topBtnArr[selected];
    if (selectedBtn.selected) {
        return;
    }else{
        selectedBtn.selected = !selectedBtn.selected;
        GGLog(@"选中了下标为%ld的按钮",selected);
        
    }
    for (int i = 0; i <self.topBtnArr.count; i ++) {
        if (i != selected) {
            UIButton *otherBtn = self.topBtnArr[i];
            otherBtn.selected = NO;
        }
    }
}

#pragma mark --- UITableViewDataSource ---
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
    ReadPostListTableViewCell *cell = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
    SeniorPostDataModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SeniorPostDataModel *model = self.dataSource[indexPath.row];
    
    UIViewController *vc;
    if (model.postType == 2) { //投票
        TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
        tvpdVC.postModel.postId = model.postId;
        vc = tvpdVC;
    }else{
        ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
        tpdVC.postModel.postId = model.postId;
        vc = tpdVC;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --请求
//获取用户关注版块的帖子列表(0刷新1加载)
-(void)requestListUserAttenPost:(NSInteger)refreshType
{
    [self.tableView ly_startLoading];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"sectionIds"] = self.model.sectionIds;
    parameters[@"sortOrder"] = @(_sortOrder);
    parameters[@"loadType"] = @(refreshType);
    parameters[@"loadTime"] = @([[self getLoadTime:refreshType] integerValue]);
    parameters[@"lastCommentTime"] = @([[self getLastCommentTime:refreshType] integerValue]);
    parameters[@"page"] = @(_page);
    parameters[@"rate"] = @(_rate);
    parameters[@"postIds"] = [self getPostIds];
    [HttpRequest getWithURLString:ListUserAttenPost parameters:parameters success:^(id responseObject) {
        NSMutableArray *dataArr = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if (dataArr.count>0) {
            if (refreshType) {
                [self.dataSource addObjectsFromArray:dataArr];
                if (dataArr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                //说明是空数组获取数据
                if (self.dataSource.count<=0) {
                    if (dataArr.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                self.dataSource = [[dataArr arrayByAddingObjectsFromArray:self.dataSource] mutableCopy];
                [self.tableView.mj_header endRefreshing];
            }
            self. page++;
        }else{
            if (refreshType) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                //说明是空数组获取数据
                if (self.dataSource.count<=0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        if (refreshType) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView ly_endLoading];
    }];
}

//请求版块帖子列表(0刷新1加载)
-(void)requestListPostForSection:(NSInteger)refreshType
{
    [self.tableView ly_startLoading];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (self.model.sectionId) {
        parameters[@"sectionId"] = @(self.model.sectionId);
    }
    parameters[@"sortOrder"] = @(_sortOrder);
    parameters[@"loadType"] = @(refreshType);
    parameters[@"loadTime"] = @([[self getLoadTime:refreshType] integerValue]);
    parameters[@"lastCommentTime"] = @([[self getLastCommentTime:refreshType] integerValue]);
    parameters[@"page"] = @(_page);
    parameters[@"rate"] = @(_rate);
    parameters[@"postIds"] = [self getPostIds];
    [HttpRequest getWithURLString:ListPostForSection parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *dataArr = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        if (dataArr.count>0) {
            if (refreshType) {
                [self.dataSource addObjectsFromArray:dataArr];
                if (dataArr.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                //说明是空数组获取数据
                if (self.dataSource.count<=0) {
                    if (dataArr.count < 10) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer endRefreshing];
                    }
                }
                self.dataSource = [[dataArr arrayByAddingObjectsFromArray:self.dataSource] mutableCopy];
                [self.tableView.mj_header endRefreshing];
            }
            self. page++;
        }else{
            if (refreshType) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                //说明是空数组获取数据
                if (self.dataSource.count<=0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        if (refreshType) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView ly_endLoading];
    }];
}

//获取loadtime
-(NSString *)getLoadTime:(NSInteger)refreshType
{
    NSString *loadTime = @"";
    if (self.dataSource.count>0) {
        if (refreshType) {
            SeniorPostDataModel *model = [self.dataSource lastObject];
            loadTime = model.createStamp;
        }else{
            SeniorPostDataModel *model = [self.dataSource firstObject];
            loadTime = model.createStamp;
        }
    }
    return loadTime;
}

//获取lastCommentTime
-(NSString *)getLastCommentTime:(NSInteger)refreshType
{
    NSString *lastCommentTime = @"";
    if (self.dataSource.count>0) {
        if (refreshType) {
            SeniorPostDataModel *model = [self.dataSource lastObject];
            lastCommentTime = model.lastCommentTime;
        }else{
            SeniorPostDataModel *model = [self.dataSource firstObject];
            lastCommentTime = model.lastCommentTime;
        }
    }
    return lastCommentTime;
}

//获取当前界面所有已存在帖子的id总集postIds
-(NSString *)getPostIds
{
    NSMutableString *postIds = @"".mutableCopy;
    if (self.dataSource.count>0) {
        for (SeniorPostDataModel *model in self.dataSource) {
            [postIds appendString:[NSString stringWithFormat:@"%ld,",(long)model.postId]];
        }
        [postIds deleteCharactersInRange:NSMakeRange(postIds.length-1, 1)];
    }
    //    NSLog(@"postIds:%@",postIds);
    return postIds.copy;
}

@end
