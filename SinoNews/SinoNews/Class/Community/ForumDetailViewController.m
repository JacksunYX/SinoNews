//
//  ForumDetailViewController.m
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumDetailViewController.h"
#import "CommunitySearchVC.h"
#import "EditSelectViewController.h"

#import "ForumDetailTableViewCell.h"
#import "ReadPostListTableViewCell.h"

#import "SectionNoticeModel.h"

@interface ForumDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MLMSegmentHeadDelegate,PYSearchViewControllerDelegate>
@property (nonatomic,strong) UIButton *attentionBtn;
@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *noticesArr;
@property (nonatomic,strong) NSMutableArray *topsArr;
@property (nonatomic,strong) NSMutableArray *sectionsArr;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIButton *addPostBtn;

@property (nonatomic,assign) BOOL haveUnFold;   //是否已展开
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) MLMSegmentHead *segHead;
@property (nonatomic,strong) NSDictionary *lastReplyDic;
@property (nonatomic,assign) NSInteger sortOrder;
@property (nonatomic,assign) NSInteger currentSectionId;
//用来区分好文和精华
@property (nonatomic,assign) NSInteger rate;

@end

@implementation ForumDetailViewController
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _headView.backgroundColor = WhiteColor;
    }
    return _headView;
}

-(UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        _footView.backgroundColor = HexColor(#F3F5F4);
        
        UIButton *topBtn = [UIButton new];
        topBtn.backgroundColor = WhiteColor;
        [_footView addSubview:topBtn];
        topBtn.sd_layout
        .topEqualToView(_footView)
        .leftEqualToView(_footView)
        .rightEqualToView(_footView)
        .bottomSpaceToView(_footView, 10)
        ;
        [topBtn setBtnFont:PFFontL(12)];
        [topBtn setNormalTitle:@"展开查看更多"];
        [topBtn setSelectedTitle:@"收起"];
        [topBtn setNormalTitleColor:HexColor(#ABB2C3)];
        [topBtn setSelectedTitleColor:HexColor(#ABB2C3)];
        [topBtn setNormalImage:UIImageNamed(@"forum_downArrow")];
        [topBtn setSelectedImage:UIImageNamed(@"forum_upArrow")];
        topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        topBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -170);
        [topBtn addTarget:self action:@selector(checkMoreAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationView];
    
    //默认按回复时间排序
    self.sortOrder = 1;
    
    [self requestListTopPostForSection];
}

//修改导航栏显示
-(void)addNavigationView
{
    UIBarButtonItem *searchBtn = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(@"forum_search")];
    
    _attentionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 26)];
    [_attentionBtn setNormalImage:UIImageNamed(@"forum_notAttention")];
    [_attentionBtn setSelectedImage:UIImageNamed(@"forum_attention")];
    _attentionBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc]initWithCustomView:_attentionBtn];
    
    //查询本地
    NSArray *localSections = [MainSectionModel getLocalAttentionSections];
    if (localSections.count>0) {
        for (int i =0; i < localSections.count; i ++) {
            MainSectionModel *model = localSections[i];
            if (model.sectionId == self.sectionId) {
                GGLog(@"此版块已关注了");
                _attentionBtn.selected = YES;
                break;
            }
        }
    }
    
    self.navigationItem.rightBarButtonItems = @[searchBtn,rightBtn2];
}

-(void)setUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = WhiteColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = HexColor(#E3E3E3);
    [self.view addSubview:_tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0))
    ;
    [self.tableView updateLayout];

    [_tableView registerClass:[ForumDetailTableViewCell class] forCellReuseIdentifier:ForumDetailTableViewCellID];
    [_tableView registerClass:[ReadPostListTableViewCell class] forCellReuseIdentifier:ReadPostListTableViewCellID];
    @weakify(self);
    self.tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self requestListPostForSection:0];
    }];
    self.tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        [self requestListPostForSection:1];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    _addPostBtn = [UIButton new];
    [self.view addSubview:_addPostBtn];
    _addPostBtn.sd_layout
    .rightSpaceToView(self.view, 30)
    .bottomSpaceToView(self.view, BOTTOM_MARGIN + 30)
    .widthIs(42)
    .heightEqualToWidth()
    ;
    [_addPostBtn setNormalImage:UIImageNamed(@"tabbar_forumPost")];
    [_addPostBtn whenTap:^{
        @strongify(self);
        if ([YXHeader checkLogin]) {
            EditSelectViewController *esVC = [EditSelectViewController new];
            esVC.sectionId = self.currentSectionId;
            
            [self presentViewController:[[RTRootNavigationController alloc]initWithRootViewController:esVC] animated:YES completion:nil];
        }
    }];
    _addPostBtn.hidden = YES;
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNews" title:@"暂无数据"];
}

//分类
-(void)addSegment
{
    if (_segHead) {
        return;
    }
    NSMutableArray *segTitles = [NSMutableArray new];
    for (int i = 0; i<self.sectionsArr.count; i ++) {
        MainSectionModel *sectionModel = self.sectionsArr[i];
        [segTitles addObject:sectionModel.name];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 80, 44) titles:segTitles headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.2;
    _segHead.fontSize = 14;
    _segHead.lineHeight = 2;
    _segHead.maxTitles = 5;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    //    _segHead.deSelectColor = HexColor(#323232);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 0;
    _segHead.singleW_Add = 25;
    _segHead.delegate = self;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:nil completion:^{
        @strongify(self);
        [self.headView addSubview:self.segHead];
    }];
    
    
    UIView *sepLine = [UIView new];
    //    sepLine.backgroundColor = kWhite(0.1);
    [self.headView addSubview:sepLine];
    sepLine.sd_layout
    .rightSpaceToView(self.headView, 80)
    .centerYEqualToView(self.headView)
    .widthIs(1)
    .heightIs(20)
    ;
    sepLine.hidden = YES;
    //添加阴影
    
    sepLine.layer.shadowColor = GrayColor.CGColor;
    sepLine.layer.shadowOffset = CGSizeMake(-1, 0);
    sepLine.layer.shadowOpacity = 1;
    sepLine.layer.shouldRasterize = NO;
    sepLine.layer.shadowPath = [UIBezierPath bezierPathWithRect:sepLine.bounds].CGPath;
    
    UIButton *sortBtn = [UIButton new];
    [self.headView addSubview:sortBtn];
    sortBtn.sd_layout
    .rightSpaceToView(self.headView, 10)
    .leftSpaceToView(sepLine, 10)
    .heightIs(20)
    .centerYEqualToView(self.headView)
    ;
    [sortBtn setNormalTitle:@"按回复"];
    [sortBtn setSelectedTitle:@"按发帖"];
    [sortBtn setNormalTitleColor:HexColor(#626262)];
    [sortBtn setSelectedTitleColor:HexColor(#626262)];
    [sortBtn setBtnFont:PFFontL(14)];
    [sortBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
}

//搜索点击
-(void)searchAction
{
    PYSearchViewController *sVC = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"名利场快速通道" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        CommunitySearchVC *csVC = [CommunitySearchVC new];
        csVC.keyword = searchText;
        csVC.sectionId = self.sectionId;
        searchViewController.searchResultController = csVC;
    }];
    sVC.delegate = self;
    sVC.searchResultShowMode = PYSearchResultShowModeEmbed;
    sVC.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    sVC.hotSearchStyle = PYHotSearchStyleRankTag;
    sVC.searchHistoryTitle = @"历史搜索";
    sVC.searchBarBackgroundColor = HexColor(#F3F5F4);
    sVC.searchBarCornerRadius = 4;
    [sVC.cancelButton setBtnFont:PFFontL(14)];
    [sVC.cancelButton setNormalTitleColor:HexColor(#161A24)];
    
    //修改搜索框
    //取出输入框
    UIView *searchTextField = nil;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        searchTextField = [sVC.searchBar valueForKey:@"_searchField"];
    }else{
        for (UIView *subView in sVC.searchBar.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchTextField = subView;
                break;
            }
        }
    }
    if (searchTextField) {
        //备注文字颜色
        [((UITextField *)searchTextField) setValue:HexColor(#939393) forKeyPath:@"_placeholderLabel.textColor"];
    }
    //修改输入框左边的搜索图标
    [sVC.searchBar setImage:UIImageNamed(@"attention_search") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:sVC];
    //不加不这句话，搜索关键字的table上面会空出一大块
    sVC.navigationController.navigationBar.translucent = NO;
    [self presentViewController:nav animated:NO completion:nil];
}

//关注点击
-(void)attentionAction:(UIButton *)sender
{
    MainSectionModel *model = [MainSectionModel new];
    model.name = self.navigationItem.title;
    model.sectionId = self.sectionId;
    model.icon = self.icon;
    if (sender.selected==NO) {
        [MainSectionModel addANew:model];
        sender.selected = YES;
        LRToast(@"关注成功");
    }else{
        [MainSectionModel remove:model];
        LRToast(@"取消关注");
        sender.selected = NO;
    }
}

//查看更多、收起点击事件
-(void)checkMoreAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.haveUnFold = sender.selected;
    if (sender.selected) {
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -70);
    }else{
        sender.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -170);
    }
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

//排序点击
-(void)sortClick:(UIButton *)sender
{
    UIAlertController *popVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sortByPostTime = [UIAlertAction actionWithTitle:@"按发帖时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.selected = YES;
        self.sortOrder = 0;
        [self clearAndReloadTableView];
        [self requestListPostForSection:0];
    }];
    UIAlertAction *sortByReplyTime = [UIAlertAction actionWithTitle:@"按回复时间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.selected = NO;
        self.sortOrder = 1;
        [self clearAndReloadTableView];
        [self requestListPostForSection:0];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancel setValue:HexColor(#8C8C8C) forKey:@"titleTextColor"];
    [popVC addAction:sortByReplyTime];
    [popVC addAction:sortByPostTime];
    [popVC addAction:cancel];
    [self presentViewController:popVC animated:YES completion:nil];
}

//清除数据，刷新界面
-(void)clearAndReloadTableView
{
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark -- PYSearchViewControllerDelegate
-(void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    if (![NSString isEmpty:[searchText removeSpace]]) {
        [self requestPost_autoComplete:searchText vc:searchViewController];
    }
}

#pragma mark --- UITableViewDataSource ---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.noticesArr.count;
    }
    if (section == 1) {
        return self.topsArr.count;
    }
    if (section == 2) {
        return self.dataSource.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ForumDetailTableViewCell *cell0 = (ForumDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumDetailTableViewCellID];
        NSDictionary *noticeModel = self.noticesArr[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"content"] = noticeModel[@"content"];
        dic[@"label"] = @"公告";
        [cell0 setData:dic];
        cell = cell0;
    }else if (indexPath.section == 1) {
        ForumDetailTableViewCell *cell1 = (ForumDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumDetailTableViewCellID];
        SeniorPostDataModel *topModel = self.topsArr[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[@"content"] = topModel.postTitle;
        dic[@"label"] = @"置顶";
        [cell1 setData:dic];
        cell = cell1;
    }else if (indexPath.section == 2) {
        ReadPostListTableViewCell *cell2 = (ReadPostListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReadPostListTableViewCellID];
        SeniorPostDataModel *model = self.dataSource[indexPath.row];
        cell2.model = model;
        cell = cell2;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:ScreenW tableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1&&self.topsArr.count>3) {
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 50;
    }
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1&&self.topsArr.count>3) {
        UIView *view = self.footView;
        
        return view;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2&&self.sectionsArr.count>0) {
        UIView *view = self.headView;
        [self addSegment];
        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *noticeModel = self.noticesArr[indexPath.row];
        NSString *param = noticeModel[@"param"];
        NSInteger type = [noticeModel[@"type"] integerValue];
        UIViewController *pushVC;
        switch (type) {
            case 101:   //普通新闻
            {
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = param.integerValue;
                pushVC = ndVC;
            }
                break;
            case 102:   //问答
            {
                CatechismViewController *cVC = [CatechismViewController new];
                cVC.news_id = param.integerValue;
                pushVC = cVC;
            }
                break;
            case 103:   //投票
            {
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = param.integerValue;
                ndVC.isVote = YES;
                pushVC = ndVC;
            }
                break;
            case 201:   //普通帖子
            {
                ThePostDetailViewController *tpdVC = [ThePostDetailViewController new];
                tpdVC.postModel.postId = param.integerValue;
                pushVC = tpdVC;
            }
                break;
            case 202:   //投票帖子
            {
                TheVotePostDetailViewController *tvpdVC = [TheVotePostDetailViewController new];
                tvpdVC.postModel.postId = param.integerValue;
                pushVC = tvpdVC;
            }
                break;
            case 301:   //外链
            {
                [[UIApplication sharedApplication] openURL:UrlWithStr(param)];
                return;
            }
                
            default:
                break;
        }
        [self.navigationController pushViewController:pushVC animated:YES];
        
    }else if (indexPath.section == 1||indexPath.section == 2) {
        SeniorPostDataModel *model;
        if (indexPath.section == 1) {
            model = self.topsArr[indexPath.row];
        }else if (indexPath.section == 2){
            model = self.dataSource[indexPath.row];
        }
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
}

#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{

    [self clearAndReloadTableView];
    MainSectionModel *model = self.sectionsArr[index];
    if (CompareString(model.name, @"好文")) {
        _rate = 1;
    }else if (CompareString(model.name, @"精华")){
        _rate = 2;
    }else{
        _rate = 0;
    }
    _currentSectionId = model.sectionId;
    
    [self requestListPostForSection:0];
}


#pragma mark --- 请求
//获取版块公告
-(void)requestListTopPostForSection
{
    ShowHudOnly;
    [HttpRequest getWithURLString:ListTopPostForSection parameters:@{@"sectionId":@(_sectionId)} success:^(id responseObject) {
        HiddenHudOnly;
        NSDictionary *dic = responseObject[@"data"];
        self.noticesArr = dic[@"notices"];
        self.topsArr = [SeniorPostDataModel mj_objectArrayWithKeyValuesArray:dic[@"tops"]];
        self.sectionsArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:dic[@"sections"]];
        //拼接好文和精华的版块
        MainSectionModel *sectionModel1 = [MainSectionModel new];
        sectionModel1.name = @"精华";
        sectionModel1.sectionId = self.sectionId;
        [self.sectionsArr insertObject:sectionModel1 atIndex:0];
        MainSectionModel *sectionModel2 = [MainSectionModel new];
        sectionModel2.name = @"好文";
        sectionModel2.sectionId = self.sectionId;
        [self.sectionsArr insertObject:sectionModel2 atIndex:0];
        //自己拼接一个全部
        MainSectionModel *sectionModel3 = [MainSectionModel new];
        sectionModel3.name = @"全部";
        sectionModel3.sectionId = self.sectionId;
        [self.sectionsArr insertObject:sectionModel3 atIndex:0];
        self.currentSectionId = self.sectionId;
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
    }];
}

//获取版块帖子列表(0刷新，1加载)
-(void)requestListPostForSection:(NSInteger)refreshType
{
    [self.tableView ly_startLoading];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"sectionId"] = @(_currentSectionId);
    parameters[@"sortOrder"] = @(_sortOrder);
    parameters[@"rate"] = @(_rate);
    parameters[@"loadType"] = @(refreshType);
    parameters[@"loadTime"] = @([[self getLoadTime:refreshType] integerValue]);
    parameters[@"lastCommentTime"] = @([[self getLastCommentTime:refreshType] integerValue]);
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
        self.addPostBtn.hidden = NO;
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        if (refreshType) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        [self.tableView ly_endLoading];
    }];
}

//搜索关键字补全
-(void)requestPost_autoComplete:(NSString *)keyword vc:(PYSearchViewController *)searchVC
{
    [HttpRequest getWithURLString:Post_autoComplete parameters:@{@"keyword":keyword} success:^(id responseObject) {
        searchVC.searchSuggestions = responseObject[@"data"];
    } failure:nil];
    
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
        [postIds appendString:@"["];
        for (SeniorPostDataModel *model in self.dataSource) {
            [postIds appendString:[NSString stringWithFormat:@"%ld,",model.postId]];
        }
        [postIds deleteCharactersInRange:NSMakeRange(postIds.length-1, 1)];
        [postIds appendString:@"]"];
    }
//    NSLog(@"postIds:%@",postIds);
    return postIds.copy;
}

@end
