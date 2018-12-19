//
//  ReadThePostMainVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadThePostMainVC.h"
#import "ReadPostChildViewController.h"
#import "CommunitySearchVC.h"

#import "PostListSearchModel.h"

#import "XLChannelControl.h"        //频道管理页面

@interface ReadThePostMainVC ()<MLMSegmentHeadDelegate,PYSearchViewControllerDelegate>
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) UIView *customTitleView;
@property (nonatomic, strong) NSMutableArray *titlesList; //版块标题数组
@property (nonatomic, strong) NSMutableArray *sectionsList; //版块数组
@end

@implementation ReadThePostMainVC
-(NSMutableArray *)titlesList
{
    if (!_titlesList) {
        _titlesList = [NSMutableArray new];
    }
    return _titlesList;
}

-(NSMutableArray *)sectionsList
{
    if (!_sectionsList) {
        _sectionsList = [NSMutableArray new];
    }
    return _sectionsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hiddenTopLine];
    
    [self addNavigationView];
    
    @weakify(self);
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNet" title:@"" refreshBlock:^{
        @strongify(self);
        ShowHudOnly;
        [self requestListMainSection];
    }];
    
    [self requestListMainSection];
    
    //监听本地关注版块版块变化
    //0->非零
    /*
    [kNotificationCenter addObserverForName:SectionsIncreaseNotify object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self resetSectionSeg:YES];
    }];
    ////非零->0
    [kNotificationCenter addObserverForName:SectionsReduceNotify object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self resetSectionSeg:NO];
    }];
    */
    //数量变化
    [kNotificationCenter addObserverForName:SectionsChangeNotify object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        [self resetWithLocalAttentionSectionChange];
    }];
}

//根据全局保存的本地关注版块数组长度来重新设置segment界面显示
-(void)resetSectionSeg:(BOOL)increase
{
    if (increase) {
        MainSectionModel *sectionModel = [MainSectionModel new];
        sectionModel.name = @"关注版块";
        [self.sectionsList insertObject:sectionModel atIndex:0];
        [self.titlesList insertObject:@"关注版块" atIndex:0];
    }else{
        [self.sectionsList removeObjectAtIndex:0];
        [self.titlesList removeObjectAtIndex:0];
    }
    [self reloadChildVCWithTitles:self.titlesList];
}

//根据本地关注版块版块数量变化重置segment显示
-(void)resetWithLocalAttentionSectionChange
{
    NSMutableArray *localSections = [MainSectionModel getLocalAttentionSections];
    //如果本地关注版块已无数据
    if (localSections.count<=0) {
        if (self.sectionsList.count>0) {
            //之前的数组还有“关注版块”这一项，直接移除重置
            for (MainSectionModel *model in self.sectionsList) {
                if ([model.name isEqualToString:@"关注版块"]) {
                    //移除第一个，因为关注版块必定是第一个
                    [self.sectionsList removeObjectAtIndex:0];
                    [self.titlesList removeObjectAtIndex:0];
                    break;
                }
            }
        }
    }else{  //如果本地关注版块有数据
        if (self.sectionsList.count>0) {
            //之前的数组还有“关注版块”这一项，重置
            int i = 0;
            for (MainSectionModel *model in self.sectionsList) {
                //替换sectionIds
                if ([model.name isEqualToString:@"关注版块"]) {
                    NSMutableString *sectionIds = @"".mutableCopy;
                    for (MainSectionModel *model2 in localSections) {
                        [sectionIds appendFormat:@"%ld,",model2.sectionId];
                    }
                    //移除最后的‘，’
                    [sectionIds deleteCharactersInRange:NSMakeRange(sectionIds.length-1, 1)];
                    model.sectionIds = sectionIds;
                    break;
                }
                i ++;
            }
            //说明之前数组并没有‘关注版块’
            if (i == self.sectionsList.count) {
                [self addLocalAttentionSection:localSections];
            }
        }else{  //之前的数组没有“关注版块”这一项，添加
            [self addLocalAttentionSection:localSections];
        }
        
    }
    
    [self reloadChildVCWithTitles:self.titlesList];
}

//将关注版块版块数据添加进当前seg数组
-(void)addLocalAttentionSection:(NSMutableArray *)localSections
{
    MainSectionModel *model = [MainSectionModel new];
    model.name = @"关注版块";
    NSMutableString *sectionIds = @"".mutableCopy;
    for (MainSectionModel *model2 in localSections) {
        [sectionIds appendFormat:@"%ld,",model2.sectionId];
    }
    //移除最后的‘，’
    [sectionIds deleteCharactersInRange:NSMakeRange(sectionIds.length-1, 1)];
    model.sectionIds = sectionIds;
    [self.sectionsList insertObject:model atIndex:0];
    [self.titlesList insertObject:@"关注版块" atIndex:0];
}

//修改导航栏显示
-(void)addNavigationView
{
    _customTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    //    _customTitleView.backgroundColor = RedColor;
    self.navigationItem.titleView = _customTitleView;
    
    //切换频道和搜索按钮
    UIButton *addChannel = [UIButton new];
    UIButton *search = [UIButton new];
    //    addChannel.backgroundColor = Arc4randomColor;
    //    search.backgroundColor = Arc4randomColor;
    
    [_customTitleView sd_addSubviews:@[
                                       search,
                                       addChannel,
                                       ]];
    search.sd_layout
    .rightEqualToView(_customTitleView)
    .centerYEqualToView(_customTitleView)
    .widthIs(30)
    .heightEqualToWidth()
    ;
    [search setNormalImage:UIImageNamed(@"forum_search")];
    [search addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    addChannel.sd_layout
    .centerYEqualToView(_customTitleView)
    .rightSpaceToView(search, 0)
    .widthIs(30)
    .heightEqualToWidth()
    ;
    [addChannel setNormalImage:UIImageNamed(@"section_channels")];
    [addChannel addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    /*
    UIView *sepLine = [UIView new];
    //    sepLine.backgroundColor = kWhite(0.1);
    [_customTitleView addSubview:sepLine];
    sepLine.sd_layout
    .rightSpaceToView(_customTitleView, 85)
    .centerYEqualToView(_customTitleView)
    .widthIs(1)
    .heightIs(20)
    ;
    //添加阴影
    sepLine.layer.shadowColor = GrayColor.CGColor;
    sepLine.layer.shadowOffset = CGSizeMake(-5, 0);
    sepLine.layer.shadowOpacity = 1;
    sepLine.layer.shouldRasterize = NO;
    sepLine.layer.shadowPath = [UIBezierPath bezierPathWithRect:sepLine.bounds].CGPath;
     */
}

-(void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)searchAction
{
    PYSearchViewController *sVC = [PYSearchViewController searchViewControllerWithHotSearches:@[] searchBarPlaceholder:@"名利场快速通道" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        CommunitySearchVC *csVC = [CommunitySearchVC new];
        csVC.keyword = searchText;
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
    [sVC.searchBar setImage:UIImageNamed(@"searchBar_icon") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    //修改输入框右边的清除图标
    //    [sVC.searchBar setImage:UIImageNamed(@"") forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    // 3. present the searchViewController
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:sVC];
    //不加不这句话，搜索关键字的table上面会空出一大块
    sVC.navigationController.navigationBar.translucent = NO;
    [self presentViewController:nav animated:NO completion:nil];
}

//处理版块数据
-(void)processSectionArr:(NSMutableArray *)sectionArr
{
    for (int i = 0; i < sectionArr.count; i ++) {
        MainSectionModel *sectionModel = sectionArr[i];
        [self.titlesList addObject:sectionModel.name];
    }
    NSMutableArray *attentionArr = [MainSectionModel getLocalAttentionSections];
    if (attentionArr.count>0) {
        [self addLocalAttentionSection:attentionArr];
    }
    [self.sectionsList addObjectsFromArray:sectionArr];

    [self reloadChildVCWithTitles:self.titlesList];
}

//将版块模型转换成频道模型
-(NSMutableArray *)processToXLChannelModel
{
    NSMutableArray *titles = [NSMutableArray new];
    for (int i = 0; i < self.sectionsList.count; i ++) {
        XLChannelModel *model = [XLChannelModel new];
        MainSectionModel *sectionModel = self.sectionsList[i];
        model.channelId = [NSString stringWithFormat:@"%ld",sectionModel.sectionId];
        model.channelIds = sectionModel.sectionIds;
        model.channelName = sectionModel.name;
        if ([model.channelName containsString:@"关注版块"]) {
            model.status = 2;
        }
        [titles addObject:model];
    }
    return titles;
}

//将频道模型转换成版块模型
-(void)processToSectionModelsWith:(NSArray *)channelModels
{
    [self.titlesList removeAllObjects];
    [self.sectionsList removeAllObjects];
    for (int i = 0; i<channelModels.count;i ++) {
        XLChannelModel *model1 = channelModels[i];
        MainSectionModel *model2 = [MainSectionModel new];
        model2.sectionId = [model1.channelId integerValue];
        model2.sectionIds = model1.channelIds;
        model2.name = model1.channelName;
        [self.titlesList addObject:model1.channelName];
        [self.sectionsList addObject:model2];
    }
    [self reloadChildVCWithTitles:self.titlesList];
}

//比对编辑返回的数组跟当前界面的版块数组是否有变化
//只要有一个数据顺序对不上，就是出现了变化
-(BOOL)compareArr1:(NSArray *)arr1 arr2:(NSArray *)arr2
{
    BOOL isEqual = NO;
    if (arr1.count == arr2.count) {
        for (int i = 0; i<arr1.count; i ++) {
            XLChannelModel *model = arr1[i];
            XLChannelModel *model2 = arr2[i];
            if (CompareString(model.channelName, model2.channelName)) {
                isEqual = YES;
            }else{
                isEqual = NO;
                break;
            }
        }
    }
    if (isEqual) {
        GGLog(@"比对结果：版块顺序未变化");
    }else{
        GGLog(@"比对结果：版块顺序已变化");
    }
    return isEqual;
}

#pragma mark -- PYSearchViewControllerDelegate
-(void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    if (![NSString isEmpty:[searchText removeSpace]]) {
        [self requestPost_autoComplete:searchText vc:searchViewController];
    }
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW - 60, 44) titles:titles headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.2;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 2;
    _segHead.maxTitles = 4;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    //    _segHead.deSelectColor = HexColor(#323232);
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setDeSelectColor:value];
    });
    _segHead.bottomLineHeight = 0;
    _segHead.singleW_Add = 40;
    _segHead.delegate = self;
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self getvcArrWith:titles]];
    _segScroll.countLimit = 0;
    _segScroll.addTiming = SegmentAddScale;
    _segScroll.addScale = 0.2;
    
    @weakify(self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        @strongify(self);
        [self.customTitleView addSubview:self.segHead];
        [self.view addSubview:self.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    
}

- (NSArray *)getvcArrWith:(NSArray *)titles
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < titles.count; i ++) {
        
        ReadPostChildViewController *vc = [ReadPostChildViewController new];
        vc.model = self.sectionsList[i];
        [arr addObject:vc];
        
    }
    return arr;
}

//全部频道
-(void)more:(UIButton *)btn
{
    if (self.sectionsList.count<=0) {
        return;
    }
    @weakify(self)
    XLChannelControl *xccc = [XLChannelControl shareControl];
    xccc.naviTitle = @"全部版块";
    xccc.cannotDelete = YES;
    NSMutableArray *processArr = [self processToXLChannelModel];
    [xccc showChannelViewWithInUseTitles:[self processToXLChannelModel] unUseTitles:nil finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        @strongify(self)
        //如果顺序发生变化，需要重新生成子界面
        if (![self compareArr1:inUseTitles arr2:processArr]) {
            [self processToSectionModelsWith:inUseTitles];
        }
    } click:nil];
}

#pragma mark --- MLMSegmentHeadDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    
}

//搜索关键字补全
-(void)requestPost_autoComplete:(NSString *)keyword vc:(PYSearchViewController *)searchVC
{
    [HttpRequest getWithURLString:Post_autoComplete parameters:@{@"keyword":keyword} success:^(id responseObject) {
        searchVC.searchSuggestions = responseObject[@"data"];
    } failure:nil];
    
}

#pragma mark --请求
//请求主版块数据
-(void)requestListMainSection
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:ListMainSection parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        NSMutableArray *listArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //拼接一个关注作者
        MainSectionModel *author = [MainSectionModel new];
        author.name = @"关注作者";
        author.sectionId = -1;
        [listArr insertObject:author atIndex:0];
        //拼接一个全部
        MainSectionModel *all = [MainSectionModel new];
        all.name = @"全部";
        [listArr insertObject:all atIndex:0];
        
        [self processSectionArr:listArr];
        [self.view ly_endLoading];
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

@end
