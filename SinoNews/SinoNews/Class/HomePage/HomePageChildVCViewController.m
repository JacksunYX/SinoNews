//
//  HomePageChildVCViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageChildVCViewController.h"
#import "NewsDetailViewController.h"
#import "TopicViewController.h"
#import "PayNewsViewController.h"
#import "RankDetailViewController.h"
#import "TopicViewController.h"

#import "HeadBannerView.h"
#import "XLChannelModel.h"
#import "HomePageBannerModel.h"

#import "HomePageFirstKindCell.h"
#import "HomePageSecondKindCell.h"
#import "HomePageThirdKindCell.h"
#import "HomePageFourthCell.h"

#define HeadViewHeight (ScreenW * 172 / 345)

@interface HomePageChildVCViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong) NSMutableArray *adArr; //广告数组
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) NSInteger page; //页面(起始为1)
@end

@implementation HomePageChildVCViewController

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

-(NSMutableArray *)adArr
{
    if (!_adArr) {
        _adArr = [NSMutableArray new];
    }
    return _adArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addTableView];
    
//    GGLog(@"news_id:%@",self.news_id);
    NSString *notice = @"暂无数据";
    if(CompareString(GetSaveString(self.news_id), @"作者")){
        notice = @"点击左上角按钮搜索作者并关注";
    }
    
    self.tableView.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNews" title:notice];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:ClearBrowsHistory object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (self.dataSource.count) {
            //遍历取消浏览标记
            for (id model in self.dataSource) {
                if ([model isKindOfClass:[HomePageModel class]]) {
                    HomePageModel *model1 = model;
                    model1.hasBrows = NO;
                }else if ([model isKindOfClass:[TopicModel class]]){
                    TopicModel *model1 = model;
                    model1.hasBrows = NO;
                }
            }
            GCDAsynMain(^{
                [self.tableView reloadData];
            });
            
        }
    }];
    
    //监听夜间模式
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NightModeChanged object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        if (self.dataSource.count) {
            
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//轮播图
-(void)creatBanner
{
    HeadBannerView *headView = [HeadBannerView new];
    
    [self.view addSubview:headView];
    
    headView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(HeadViewHeight)
    ;
    [headView updateLayout];
    headView.showTitle = YES;
    headView.bottomHeight = 5;
    [headView setupUIWithModels2:self.adArr];
    
    @weakify(self)
    headView.selectBlock = ^(NSInteger index) {
        @strongify(self)
        [self pushToVCWithIndex:index];
    };
    
    self.tableView.tableHeaderView = headView;
}

//根据下标跳转
-(void)pushToVCWithIndex:(NSInteger)index
{
    HomePageBannerModel *model = self.adArr[index];
    UIViewController *pushVC;
    if (model.topic) {  //专题
        TopicViewController *tVC = [TopicViewController new];
        tVC.topicId = model.topicId;
        pushVC = tVC;
    }else{  //非专题
        NewsDetailViewController *ndVC = [NewsDetailViewController new];
        ndVC.newsId = model.newsId;
        pushVC = ndVC;
    }
    [self.navigationController pushViewController:pushVC animated:YES];
}

-(void)addTableView
{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [self.tableView activateConstraints:^{
        self.tableView.top_attr = self.view.top_attr_safe;
        self.tableView.left_attr = self.view.left_attr_safe;
        self.tableView.right_attr = self.view.right_attr_safe;
        self.tableView.bottom_attr = self.view.bottom_attr_safe;
    }];
    @weakify(self)
    self.tableView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        self.tableView.backgroundColor = value;
//        if (UserGetBool(@"NightMode")) {
//            self.tableView.separatorColor = WhiteColor;
//        }else{
//
//        }
        
    });
//    self.tableView.separatorColor = HexColor(#E3E3E3);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);

    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册
    [_tableView registerClass:[HomePageFirstKindCell class] forCellReuseIdentifier:HomePageFirstKindCellID];
    [_tableView registerClass:[HomePageSecondKindCell class] forCellReuseIdentifier:HomePageSecondKindCellID];
    [_tableView registerClass:[HomePageThirdKindCell class] forCellReuseIdentifier:HomePageThirdKindCellID];
    [_tableView registerClass:[HomePageFourthCell class] forCellReuseIdentifier:HomePageFourthCellID];
    
    self.page = 1;
    _tableView.mj_header = [YXGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
            return ;
        }
        [self.tableView ly_startLoading];
        //有newsid，说明是首页的子页面

        if ([self.news_id integerValue]) {
            [self requestNews_list:0];
            //只有最新频道存在轮播图
            if ([self.news_id integerValue] == 1||CompareString(self.channel_name, @"最新")) {
//                [self requestBanner];
                [self requestNewBanner];
            }
        }else if(CompareString(GetSaveString(self.news_id), @"作者")){  //反之则是关注子页面
            [self requestAttentionNews];
        }else if(CompareString(GetSaveString(self.news_id), @"专题")){
            [self requestAttentionChannelNews];
        }

    }];
    
    _tableView.mj_footer = [YXAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.tableView.mj_header.isRefreshing||!self.dataSource.count) {
            [self.tableView.mj_footer endRefreshing];
            return ;
        }

        self.page++;

        if ([self.news_id integerValue]) {
            self.page = 1;
            [self requestNews_list:1];
        }else if(CompareString(GetSaveString(self.news_id), @"作者")){
            [self requestAttentionNews];
        }else if(CompareString(GetSaveString(self.news_id), @"专题")){
            [self requestAttentionChannelNews];
        }

    }];
    
    [_tableView.mj_header beginRefreshing];
    
//    [_tableView bindGlobalStyleForFootRefreshHandler:^{
//        @strongify(self);
//        self.page++;
//
//        if ([self.news_id integerValue]) {
//            self.page = 1;
//            [self requestNews_list:1];
//        }else if(CompareString(GetSaveString(self.news_id), @"作者")){
//            [self requestAttentionNews];
//        }else if(CompareString(GetSaveString(self.news_id), @"频道")){
//            [self requestAttentionChannelNews];
//        }
//    }];
//
//    [_tableView bindGlobalStyleForHeadRefreshHandler:^{
//        @strongify(self)
//        [self.tableView ly_startLoading];
//        //有newsid，说明是首页的子页面
//
//        if ([self.news_id integerValue]) {
//            [self requestNews_list:0];
//            //只有最新频道存在轮播图
//            if ([self.news_id integerValue] == 82||CompareString(self.channel_name, @"最新")) {
//                [self requestBanner];
//            }
//        }else if(CompareString(GetSaveString(self.news_id), @"作者")){  //反之则是关注子页面
//            [self requestAttentionNews];
//        }else if(CompareString(GetSaveString(self.news_id), @"频道")){
//            [self requestAttentionChannelNews];
//        }
//    }];
//    self.tableView.footRefreshControl.autoRefreshOnFoot = YES;
//
//    [self.tableView.headRefreshControl beginRefreshing];
}

//滚动至顶部
-(void)scrollToTop
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
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
    UITableViewCell *cell;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = (HomePageModel *)model;
        switch (model1.itemType) {
            case 400:
            case 500:
            case 100:   //无图
            {
                HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
            
            case 401:
            case 501:
            case 101:   //1图
            {
                HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
            case 403:
            case 503:
            case 103:   //3图
            {
                HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
                
            default:
                break;
        }

    }else if ([model isKindOfClass:[TopicModel class]]){
        HomePageModel *model1 = (HomePageModel *)model;
        switch (model1.itemType) {
            case 200:   //无图
            {
                HomePageFourthCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFourthCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;

            case 201:   //1图
            {
                HomePageFirstKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageFirstKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
                
            case 203:   //3图
            {
                HomePageSecondKindCell *cell1 = [tableView dequeueReusableCellWithIdentifier:HomePageSecondKindCellID];
                cell1.model = model1;
                cell = (UITableViewCell *)cell1;
            }
                break;
                
            default:
                break;
        }
        
    }else if ([model isKindOfClass:[ADModel class]]){
        HomePageThirdKindCell *cell3 = [tableView dequeueReusableCellWithIdentifier:HomePageThirdKindCellID];
        cell3.model = model;
        cell = (UITableViewCell *)cell3;
    }
    [cell addBakcgroundColorTheme];
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
    id model = self.dataSource[indexPath.row];
    //跳转
//    [UniversalMethod pushToAssignVCWithNewmodel:model];
    UIViewController *pushVC;
    NSInteger itemId = 0;
    @weakify(self);
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = model;
        itemId = model1.itemId;
        if (model1.itemType>=400&&model1.itemType<500) { //投票
            //            VoteViewController *vVC = [VoteViewController new];
            //            vVC.newsId = model1.itemId;
            //            pushVC = vVC;
            NewsDetailViewController *ndVC = [NewsDetailViewController new];
            ndVC.newsId = model1.itemId;
            ndVC.isVote = YES;
            pushVC = ndVC;
            
            ndVC.commentBlock = ^(NSInteger commentCount) {
                @strongify(self);
                model1.commentCount = commentCount;
                [self.tableView reloadData];
            };
        }else
            if (model1.itemType>=500&&model1.itemType<600) { //问答
                CatechismViewController *cVC = [CatechismViewController new];
                cVC.news_id = model1.itemId;
                pushVC = cVC;
                cVC.commentBlock = ^(NSInteger commentCount) {
                    @strongify(self);
                    model1.commentCount = commentCount;
                    [self.tableView reloadData];
                };
            }else{
                NewsDetailViewController *ndVC = [NewsDetailViewController new];
                ndVC.newsId = model1.itemId;
                pushVC = ndVC;
                ndVC.commentBlock = ^(NSInteger commentCount) {
                    @strongify(self);
                    model1.commentCount = commentCount;
                    [self.tableView reloadData];
                };
            }
        
    }else if ([model isKindOfClass:[TopicModel class]]){
        TopicModel *model2 = model;
        TopicViewController *tVC = [TopicViewController new];
        //只有专题是用的topicId
        tVC.topicId = [model2.topicId integerValue];
        itemId = [model2.topicId integerValue];
        pushVC = tVC;
    }else if ([model isKindOfClass:[ADModel class]]){
        
    }
    
    [self.navigationController pushViewController:pushVC animated:YES];
    
    //是否需要标记看过
    if ([model isKindOfClass:[HomePageModel class]]) {
        HomePageModel *model1 = model;
        if (!model1.hasBrows) {
            model1.hasBrows = YES;
            [BrowsNewsSingleton.singleton addBrowHistory:model1.itemId];
            [self.tableView reloadData];
        }
    }if ([model isKindOfClass:[TopicModel class]]){
        TopicModel *model1 = model;
        if (!model1.hasBrows) {
            model1.hasBrows = YES;
            [BrowsNewsSingleton.singleton addBrowHistory:[model1.topicId integerValue]];
            [self.tableView reloadData];
        }
    }else if ([model isKindOfClass:[ADModel class]]){
        ADModel *model1 = model;
        [UniversalMethod jumpWithADModel:model1];
    }
    
}

#pragma mark ---- 请求方法
//请求文章列表(上拉或下拉)
-(void)requestNews_list:(NSInteger)upOrDown
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
//    parameters[@"channelId"] = @([GetSaveString(self.news_id) integerValue]);
//    parameters[@"loadTime"] = @([[NSString currentTimeStr] longLongValue]);
    
    parameters[@"page"] = @(self.page);   //现在不需要这个参数,固定传1
    parameters[@"loadType"] = @(upOrDown);
    parameters[@"channelId"] = @([self.news_id integerValue]);
    if (upOrDown) {
        parameters[@"loadTime"] = @([[UniversalMethod getBottomLoadTimeWithData:self.dataSource] integerValue]);
    }else{
        parameters[@"loadTime"] = @([[UniversalMethod getTopLoadTimeWithData:self.dataSource] integerValue]);
    }
    
    [HttpRequest getWithURLString:News_list parameters:parameters success:^(id responseObject) {
        
        NSMutableArray *dataArr = [UniversalMethod getProcessNewsData:responseObject[@"data"]];
        //比对是否有阅读过的数据
        dataArr = [BrowsNewsSingleton.singleton compareBrowsHistoryWithBackgroundData:dataArr];
        self.tableView.mj_footer.hidden = NO;
        if (upOrDown == 0) {
            //数组都有数据时，需要把本地数据中的置顶先删掉，因为后台默认每次返回都带置顶
            if (self.dataSource.count>0&&dataArr.count>0) {
                for (id model in [self.dataSource copy]) {
                    //先转换成字典
                    NSDictionary *modelDic = [model mj_keyValues];
                    if (CompareString(modelDic[@"labelName"], @"置顶")) {
                        [self.dataSource removeObject:model];
                    }
                }
            }else if(self.dataSource.count==0&&dataArr.count<10){
                if (dataArr.count<=0) {
                    self.tableView.mj_footer.hidden = YES;
                }
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.dataSource = [[dataArr arrayByAddingObjectsFromArray:self.dataSource] mutableCopy];
            [self.tableView.mj_header endRefreshing];
        }else{
            if (dataArr.count) {
                [self.dataSource addObjectsFromArray:dataArr];
                if (dataArr.count<10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView ly_endLoading];
    }];
    
}

//请求banner
-(void)requestBanner
{
    
    [RequestGather requestBannerWithADId:1 success:^(id response) {
        self.adArr = response;
        if (!kArrayIsEmpty(self.adArr)) {
            [self creatBanner];
        }
//        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
    }];
    
}

//新的轮播图
-(void)requestNewBanner
{
    [HttpRequest getWithURLString:NewsSlide parameters:nil success:^(id responseObject) {
        NSArray *data = [HomePageBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.adArr = [data mutableCopy];
        if (!kArrayIsEmpty(self.adArr)) {
            [self creatBanner];
        }
    } failure:nil];
}

//获取关注的人相关文章
-(void)requestAttentionNews
{
    [HttpRequest postWithURLString:MyUserNews parameters:@{@"currPage":@(self.page)} isShowToastd:YES isShowHud:NO isShowBlankPages:NO success:^(id response) {
        NSMutableArray *dataArr = [UniversalMethod getProcessNewsData:response[@"data"]];
        //比对是否有阅读过的数据
        dataArr = [BrowsNewsSingleton.singleton compareBrowsHistoryWithBackgroundData:dataArr];
        
//        if (self.page == 1) {
//            self.dataSource = [dataArr mutableCopy];
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            if (dataArr.count) {
//                [self.dataSource addObjectsFromArray:dataArr];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        self.dataSource = [self.tableView pullWithPage:self.page data:dataArr dataSource:self.dataSource];
        
        [self.tableView reloadData];
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    } RefreshAction:nil];
}

//获取关注频道的文章列表
-(void)requestAttentionChannelNews
{
    NSMutableString *str = [@"" mutableCopy];
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    if (kArrayIsEmpty(columnArr)) {
        LRToast(@"没有任何关注的频道哦");
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }else{
        NSArray *titleList = [NSMutableArray arrayWithArray:columnArr[0]];
        for (XLChannelModel *model in titleList) {
            if (model.status!=2) {
               [str appendString:[NSString stringWithFormat:@"%@,",model.channelId]];
            }
            
        }
        if (str.length>0) {
            [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        }else{
            LRToast(@"先去关注点其他的频道吧");
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"page"] = @(self.page);
    parameters[@"channelIds"] = str;
    
    [HttpRequest getWithURLString:ListForFollow parameters:parameters success:^(id responseObject) {
        NSMutableArray *dataArr = [UniversalMethod getProcessNewsData:responseObject[@"data"]];
        //比对是否有阅读过的数据
        dataArr = [BrowsNewsSingleton.singleton compareBrowsHistoryWithBackgroundData:dataArr];
        
//        if (self.page == 1) {
//            self.dataSource = [dataArr mutableCopy];
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            if (dataArr.count) {
//                [self.dataSource addObjectsFromArray:dataArr];
//                [self.tableView.mj_footer endRefreshing];
//            }else{
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        [self.tableView pullWithPage:self.page data:dataArr dataSource:self.dataSource];
        
        [self.tableView reloadData];
        
        [self.tableView ly_endLoading];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView ly_endLoading];
    }];
}




@end
