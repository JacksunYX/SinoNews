//
//  ForumViewController.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumViewController.h"
#import "ChangeAttentionViewController.h"
#import "CommunitySearchVC.h"
#import "ForumDetailViewController.h"

#import "ForumLeftTableViewCell.h"
#import "ForumRightTableViewCell.h"

@interface ForumViewController ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>

@property (nonatomic,strong) BaseTableView *leftTable;
@property (nonatomic,strong) BaseTableView *rightTable;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger leftSelectedIndex;
@property (nonatomic,strong) UIButton *addImg;

@property (nonatomic,strong) UIButton *addPostBtn;

@end

@implementation ForumViewController
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        //虚拟数据
        /*
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
            NSInteger arr2Count = arc4random()%10 + 10;
            for (int j = 0; j < arr2Count; j++) {
                NSMutableDictionary *model = [NSMutableDictionary new];
                model[@"logo"] = logo[arc4random()%(logo.count)];
                model[@"communityName"] = communityName[arc4random()%(communityName.count)];
                //                if (i == 0) {
                //                    break;
                //                }
                [arr3 addObject:model];
            }
            [arr2 addObject:arr3];
        }
        
        [_dataSource addObject:arr2];
        */
    }
    return _dataSource;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        _bottomView.sd_layout
        .rightEqualToView(self.view)
        .heightIs(0)
        .bottomEqualToView(self.view)
        .widthIs(ScreenW*0.7)
        ;
        
        //添加控价
        UILabel *attentionMore = [UILabel new];
        attentionMore.textAlignment = NSTextAlignmentCenter;
        attentionMore.font = PFFontL(14);
        attentionMore.textColor = HexColor(#1282EE);
        [_bottomView addSubview:attentionMore];
        attentionMore.sd_layout
        .heightIs(14)
        .leftEqualToView(_bottomView)
        .rightEqualToView(_bottomView)
        .centerYEqualToView(_bottomView)
        ;
        attentionMore.text = @"关注更多 >";
        
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"版块";
    if (self.postModel) {
        self.navigationItem.title = @"选择发表到的版块";
    }
    
    [self addNavigationView];
    
    [self setBottomView];
    
    @weakify(self);
    self.view.ly_emptyView = [MyEmptyView noDataEmptyWithImage:@"noNet" title:@"" refreshBlock:^{
        @strongify(self);
        [self requestSectionTree];
    }];
    
    //监听关注版块数量变化回调
    [kNotificationCenter addObserverForName:SectionsChangeNotify object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        if (self.dataSource.count>0) {
            MainSectionModel *model = self.dataSource[0];
            model.subSections = [MainSectionModel getLocalAttentionSections];
            [self.rightTable reloadData];
            [self setBottomView];
        }
    }];
    
    [self requestSectionTree];
}

//修改导航栏显示
-(void)addNavigationView
{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left"]];
    
    if (self.postModel) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(publishAction) title:@"发表" font:PFFontL(15) titleColor:BlackColor highlightedColor:BlackColor titleEdgeInsets:UIEdgeInsetsZero];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchAction) image:UIImageNamed(@"attention_search")];
    }
    
}

-(void)back
{
    if (self.postModel) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)publishAction
{
    if (self.postModel.sectionId == 0) {
        LRToast(@"没有选择版块哟");
        return;
    }
    [self requestPublishPost];
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
//        searchTextField.backgroundColor = [UIColor colorFromHexString:@"#27dcfb"];
//        searchTextField.layer.masksToBounds = YES;
//        searchTextField.layer.cornerRadius = 3.0f;
//        searchTextField.layer.borderColor = [UIColor whiteColor].CGColor;
//        searchTextField.layer.borderWidth = 0.5;
//        ((UITextField *)searchTextField).textColor = [UIColor whiteColor];
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

-(void)setUI
{
    _leftTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTable.backgroundColor = HexColor(#EEEEEE);
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _leftTable.showsVerticalScrollIndicator = NO;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _leftTable.separatorColor = CutLineColor;
    [self.view addSubview:_leftTable];
    _leftTable.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .widthIs(ScreenW *0.3)
    ;
    [_leftTable updateLayout];
    [_leftTable registerClass:[ForumLeftTableViewCell class] forCellReuseIdentifier:ForumLeftTableViewCellID];
    [self selectTable:_leftTable atIndex:0];
    
    self.bottomView.backgroundColor = WhiteColor;
    @weakify(self);
    [self.bottomView whenTap:^{
        @strongify(self);
        [self addSection];
    }];
    
    _rightTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    .bottomSpaceToView(self.bottomView, 0)
    ;
    [_rightTable updateLayout];
    [_rightTable registerClass:[ForumRightTableViewCell class] forCellReuseIdentifier:ForumRightTableViewCellID];
    
    _addPostBtn = [UIButton new];
    [self.view addSubview:_addPostBtn];
    _addPostBtn.sd_layout
    .rightSpaceToView(self.view, 30)
    .bottomSpaceToView(self.view, 30)
    .widthIs(42)
    .heightEqualToWidth()
    ;
    [_addPostBtn setNormalImage:UIImageNamed(@"posting_icon")];
    [_addPostBtn whenTap:^{
        @strongify(self);
        if ([YXHeader checkLogin]) {
            EditSelectViewController *esVC = [EditSelectViewController new];
            
            [self presentViewController:[[RTRootNavigationController alloc]initWithRootViewController:esVC] animated:YES completion:nil];
        }
    }];
//    _addPostBtn.hidden = YES;
    
    [self setBottomView];
}

//主动选择tableView的某一row
-(void)selectTable:(UITableView *)tableview atIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [tableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (tableview == _leftTable&&self.postModel) {
        MainSectionModel *model = self.dataSource[index];
        if (model.subSections.count<=0) {
//            [self requestListSubSection:model];
        }
    }
}

//设置关注更多视图
-(void)setBottomView
{
    if (self.leftSelectedIndex == 0&&self.dataSource.count>0&&!self.postModel) {
        MainSectionModel *model = self.dataSource[0];
        CGFloat height = 40;
        if (model.subSections.count<=0) {
            height = 0;
            self.bottomView.hidden = YES;
        }else{
            self.bottomView.hidden = NO;
        }
        self.bottomView.sd_layout
        .heightIs(height)
        ;
    }else{
        self.bottomView.hidden = YES;
        self.bottomView.sd_layout
        .heightIs(0)
        ;
    }
}

//跳转修改关注版块界面
-(void)addSection
{
    ChangeAttentionViewController *caVC = [ChangeAttentionViewController new];
    @weakify(self);
    caVC.changeFinishBlock = ^(NSArray *selectArr){
        @strongify(self);
        MainSectionModel *model = self.dataSource[0];
        model.subSections = [MainSectionModel getLocalAttentionSections];
        [self.leftTable reloadData];
        [self.rightTable reloadData];
        [self.leftTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    };
    [self.navigationController pushViewController:caVC animated:YES];
}

#pragma mark -- PYSearchViewControllerDelegate
-(void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)searchBar searchText:(NSString *)searchText
{
    if (![NSString isEmpty:[searchText removeSpace]]) {
        [self requestPost_autoComplete:searchText vc:searchViewController];
    }
}

#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTable) {
        return self.dataSource.count;
    }
    if (tableView == _rightTable&&self.dataSource.count>0) {
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        return model.subSections.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _leftTable) {
        ForumLeftTableViewCell *cell1 = (ForumLeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumLeftTableViewCellID];
        MainSectionModel *model = self.dataSource[indexPath.row];
        [cell1 setTitle:model.name];
        cell = cell1;
    }else if (tableView == _rightTable) {
        ForumRightTableViewCell *cell2 = (ForumRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ForumRightTableViewCellID];
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        if (self.postModel) {
            cell2.isPost = YES;
        }
        cell2.model = model2;
        
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
//        if (arc4random()%2) {
//            return 135;
//        }
        return 0.01;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _rightTable&&self.leftSelectedIndex == 0&&self.dataSource.count>0) {
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        if (model.subSections.count<=0&&!self.postModel) {
            return 213;
        }
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *head;
    if (tableView == _rightTable&&self.dataSource.count>0) {
        head = [[UIView alloc]initWithFrame: CGRectMake(0, 0, _rightTable.frame.size.width, 0)];
        UIImageView *ADImage = [UIImageView new];
        [head addSubview:ADImage];
        ADImage.sd_layout
        .topSpaceToView(head, 10)
        .leftSpaceToView(head, 10)
        .rightSpaceToView(head, 10)
        .bottomSpaceToView(head, 10)
        ;
        /*
        NSString *imageStr = [NSString stringWithFormat:@"gameAd_%d",arc4random()%3];
        ADImage.image = UIImageNamed(imageStr);
        [ADImage whenTap:^{
            GGLog(@"点击了%ld区的广告",(long)self.leftSelectedIndex);
        }];
         */
    }
    
    return head;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView;
    if (tableView == _rightTable&&self.leftSelectedIndex == 0&&self.dataSource.count>0){
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        if (model.subSections.count<=0&&!self.postModel) {
            footView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, _rightTable.frame.size.width, 213)];
            _addImg = [UIButton new];
            UILabel *noticeLabel = [UILabel new];
            noticeLabel.font = PFFontL(14);
            noticeLabel.textColor = HexColor(#A8A8A8);
            [footView sd_addSubviews:@[
                                       _addImg,
                                       noticeLabel,
                                       ]];
            _addImg.sd_layout
            .topSpaceToView(footView, 74)
            .centerXEqualToView(footView)
            .widthIs(81)
            .heightEqualToWidth()
            ;
            [_addImg setNormalImage:UIImageNamed(@"section_add")];
            [_addImg addTarget:self action:@selector(addSection) forControlEvents:UIControlEventTouchUpInside];
            
            noticeLabel.sd_layout
            .topSpaceToView(_addImg, 34)
            .centerXEqualToView(footView)
            .heightIs(16)
            ;
            [noticeLabel setSingleLineAutoResizeWithMaxWidth:_rightTable.frame.size.width - 20];
            noticeLabel.text = @"添加感兴趣的版块";
        }
    }
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        if (self.leftSelectedIndex == indexPath.row&&!self.postModel) {
            return;
        }
        self.leftSelectedIndex = indexPath.row;
        [self.rightTable reloadData];
        [self setBottomView];
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        if (self.postModel&&model.subSections.count<=0) {
//            [self requestListSubSection:model];
        }else{
            if (model.subSections.count<=0&&self.leftSelectedIndex!=0) {
//                [self requestListSubSection:model];
            }else{
                [self.rightTable reloadData];
                [self setBottomView];
            }
        }
        self.postModel.sectionId = 0;
    }else if (tableView == _rightTable) {
        
        MainSectionModel *model = self.dataSource[self.leftSelectedIndex];
        MainSectionModel *model2 = model.subSections[indexPath.row];
        self.postModel.sectionId = model2.sectionId;
        if (!self.postModel) {
            ForumDetailViewController *fdVC = [ForumDetailViewController new];
            fdVC.navigationItem.title = GetSaveString(model2.name);
            fdVC.sectionId = model2.sectionId;
            fdVC.icon = model2.icon;
            fdVC.postCount = model2.postCount;
            [self.navigationController pushViewController:fdVC animated:YES];
        }
    }
}

#pragma mark --请求
//请求主版块数据
-(void)requestListMainSection
{
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:ListMainSection parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        NSArray *listArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        NSMutableArray *myAttentionArr = [MainSectionModel getLocalAttentionSections];
        if (listArr.count > 0) {
            MainSectionModel *model = [MainSectionModel new];
            model.name = @"我的关注";
            model.subSections = myAttentionArr;
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:model];
            if (myAttentionArr.count<=0&&self.postModel) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:listArr];
            [self setUI];
        }
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//请求子版块数据
-(void)requestListSubSection:(MainSectionModel *)model
{
    [HttpRequest getWithURLString:ListSubSection parameters:@{@"sectionId":@(model.sectionId)} success:^(id responseObject) {
        NSArray *subListArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        model.subSections = subListArr.mutableCopy;
        
        [self.rightTable reloadData];
        [self setBottomView];
    } failure:^(NSError *error) {
        [self.rightTable reloadData];
        [self setBottomView];
    }];
}

//请求版块树(直接一次性请求所有版块数据)
-(void)requestSectionTree
{
    ShowHudOnly;
    [self.view ly_startLoading];
    [HttpRequest getWithURLString:SectionTree parameters:nil success:^(id responseObject) {
        HiddenHudOnly;
        [self.view ly_endLoading];
        NSArray *listArr = [MainSectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSMutableArray *myAttentionArr = [MainSectionModel getLocalAttentionSections];
        if (listArr.count > 0) {
            
            [self.dataSource removeAllObjects];
            
            if (myAttentionArr.count<=0&&self.postModel) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:listArr];
        }
        
        MainSectionModel *model = [MainSectionModel new];
        model.name = @"我的关注";
        model.subSections = myAttentionArr;
        //需要同步二级版块篇数
        if (myAttentionArr.count > 0) {
            //标记是否需要重新保存
            BOOL canSave = NO;
            for (MainSectionModel *model in myAttentionArr) {
                for (int i = 0; i < listArr.count; i ++) {
                    MainSectionModel *model1 = listArr[i];
                    //如果有2级版块才比对
                    if (model1.subSections.count>0) {
                        for (MainSectionModel *model2 in model1.subSections) {
                            if (model2.sectionId == model.sectionId) {
                                NSLog(@"本地保存关注版块篇数更新");
                                model.postCount = model2.postCount;
                                canSave = YES;
                            }
                        }
                    }
                }
            }
//            //重新保存最新的
//            if (canSave) {
//                [MainSectionModel addMutilNews:myAttentionArr];
//                NSLog(@"更新篇数完毕");
//            }
        }
        [self.dataSource insertObject:model atIndex:0];
        
        [self setUI];
        
    } failure:^(NSError *error) {
        HiddenHudOnly;
        [self.view ly_endLoading];
    }];
}

//搜索关键字补全
-(void)requestPost_autoComplete:(NSString *)keyword vc:(PYSearchViewController *)searchVC
{
    [HttpRequest getWithURLString:Post_autoComplete parameters:@{@"keyword":keyword} success:^(id responseObject) {
        searchVC.searchSuggestions = responseObject[@"data"];
    } failure:nil];
    
}

//发表帖子
-(void)requestPublishPost
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    NSMutableDictionary *dic = [self.postModel mj_JSONObject];
    NSMutableArray *dataSource = dic[@"dataSource"];
    for (int i = 0; i < dataSource.count; i ++) {
        NSMutableDictionary *item = dataSource[i];
        if (item[@"imageData"]) {
            [item removeObjectForKey:@"imageData"];
        }
        if (item[@"videoData"]){
            [item removeObjectForKey:@"videoData"];
        }
    }
    parameters[@"postModel"] = [dic mj_JSONString];
    
    [HttpRequest postWithURLString:PublishPost parameters:parameters isShowToastd:YES isShowHud:YES isShowBlankPages:NO success:^(id response) {
        LRToast(@"发帖成功");
        //记得要从本地草稿箱移除
        [SeniorPostDataModel remove:self.postModel];
        if (self.refreshCallBack) {
            self.refreshCallBack();
        }
        GCDAfterTime(1, ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
    } failure:nil RefreshAction:nil];
}

@end
