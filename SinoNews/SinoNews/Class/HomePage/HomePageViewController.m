//
//  HomePageViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageViewController.h"
#import "XLChannelControl.h"        //频道管理页面
#import "HomePageChildVCViewController.h"
#import "MineViewController.h"
#import "SearchViewController.h"    //搜索页面
#import "ADPopView.h"
#import "HomeSearchTView.h"

@interface HomePageViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *titleList;
@property (nonatomic, strong) NSMutableArray *leaveTitleList;
@property (nonatomic, strong) UIButton *userIcon;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation HomePageViewController

-(NSMutableArray *)titleList
{
    if (!_titleList) {
        _titleList = [NSMutableArray new];
        
//        NSArray *title = @[
//                           @"最新",
//                           @"视频",
//                           @"游戏",
//                           @"娱乐",
//                           @"测试一下",
//                           @"体育",
//                           @"电子",
//                           ];
//        for (int i = 0; i < title.count; i ++) {
//            XLChannelModel *model = [XLChannelModel new];
//            model.channelId = [NSString stringWithFormat:@"%d",i + 10086];
//            model.channelName = title[i];
//            if (i < 4) {
//                [_titleList addObject:model];
//            }else{
//                model.isNew = YES;
//                [self.leaveTitleList addObject:model];
//            }
//        }
        
    }
    return _titleList;
}

-(NSMutableArray *)leaveTitleList
{
    if (!_leaveTitleList) {
        _leaveTitleList = [NSMutableArray new];
    }
    return _leaveTitleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self showOrHideLoadView:YES page:1];
    
    [self addNavigationView];
    //先从缓存里查是否有保存
    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
    if (kArrayIsEmpty(columnArr)) {
        [self requestChnanel:NO];
    }else{
        self.titleList = [NSMutableArray arrayWithArray:columnArr[0]];
        self.leaveTitleList = columnArr[1];
        [self reloadChildVCWithTitles:self.titleList];
        //比对是否有更新的频道
        [self requestChnanel:YES];
    }
    
    //监听登录
//    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UserLoginSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        @strongify(self)s
        //这里目前不要清空频道设置
//        [self requestChnanel:NO];
    }];
    
    if (!UserGetBool(HomePageNotice)) {
        [PopNoticeView showWithData:@[@"homePage_0",@"homePage_1",@"homePage_2"]];
        UserSetBool(YES, HomePageNotice);
    }else{
        [VersionCheckHelper requestToCheckVersion:^(id response) {
            if (CompareString(response, @"1")) {
                //说明不需要提示更新
                [self requestADPop];
            }
        } popUpdateView:NO];

    }
    
    [self timerRun];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

// 重复执行的定时器
- (void)timerRun
{
    //暂定每隔30秒请求一次
    NSTimer *timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(requestGetCountOfUnreadMessage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

//修改导航栏显示
-(void)addNavigationView
{
    //需要把searchbar作为导航栏的titleview时，不要直接设置，因为直接创建的searchbar高度时固定为44的，这样会把导航栏的高度撑高，不再是44，可以使用下面的方法来创建
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * ScaleW, 34)];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;

    //重构搜索框
//    UITextField *searchField = [[UITextField alloc]initWithFrame:titleView.bounds];
//    [titleView addSubview:searchField];
//    searchField.font = PFFontL(13);
//    searchField.layer.cornerRadius = 17.0f;
//    searchField.layer.masksToBounds = YES;
//    searchField.delegate = self;
//    searchField.placeholder = @" 搜个关键词试试看？";
////    @weakify(self)
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//    tap.numberOfTapsRequired = 1;
//    [searchField addGestureRecognizer:tap];
//
//    searchField.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
//        UITextField *searchView = item;
//        searchView.backgroundColor = value;
//        if (UserGetBool(@"NightMode")) {
//            searchView.backgroundColor = HexColor(#292D30);
//        }
//    });
    
    // 设置搜索框放大镜图标
    self.searchBar.lee_theme.LeeCustomConfig(@"homePage_search", ^(id item, id value) {
        [(UISearchBar *)item setImage:value forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    });
    
    
//    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
//    if (searchField) {
//        [searchField setBackgroundColor:HexColor(#f2f2f2)];
//        searchField.layer.cornerRadius = 17.0f;
//        searchField.layer.masksToBounds = YES;
//
//        searchField.delegate = self;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        tap.numberOfTapsRequired = 1;
//        [searchField addGestureRecognizer:tap];
//    }
    
    @weakify(self);
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        @strongify(self)
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            
            textField.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
                if (UserGetBool(@"NightMode")) {
                    textField.backgroundColor = HexColor(#292D30);
                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜个关键词试试看？" attributes:@{
                                                                                                                            NSForegroundColorAttributeName:HexColor(#4B4B4B),
                                                                                                                            NSFontAttributeName:Font(13),
                                                                                                                            }];
                }else{
                    textField.backgroundColor = HexColor(#f2f2f2);
                    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜个关键词试试看？" attributes:@{
                                                                                                                            NSForegroundColorAttributeName:HexColor(#959b9f),
                                                                                                                            NSFontAttributeName:Font(13),
                                                                                                                            }];
                }
            });
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 17.0f;
//            textField.layer.borderColor = HexColor(#f7f7f7).CGColor;
//            textField.layer.borderWidth = 1;
            //设置输入字体颜色
            textField.textColor = BlueColor;
            textField.delegate = self;
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            //            UIButton *cancel = (UIButton *)view;
            //            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            
        }
        //ios10以下会有背景色，去掉
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    
    _userIcon = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_userIcon setNormalImage:UIImageNamed(@"homePage_logo")];
    _userIcon.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//    LRViewBorderRadius(_userIcon, 15, 0, HexColor(#B5B5B5));
    _userIcon.layer.cornerRadius = 17;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_userIcon];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(userTouch) image:[UIImage imageNamed:@"homePage_logo"]];
}

//点击logo滚动至顶部
-(void)userTouch
{
//    GGLog(@"currentVcOrView:%@",self.segScroll.currentVcOrView);
    if (self.segScroll.currentVcOrView) {
        HomePageChildVCViewController *vc = self.segScroll.currentVcOrView;
        [vc scrollToTop];
    }
}

//让输入框无法进入编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    SearchViewController *sVC = [SearchViewController new];
    [self.navigationController pushViewController:sVC animated:NO];
    
    return NO;
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    [self showOrHideLoadView:NO page:1];
    self.titleList = [titles mutableCopy];
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    if (!self.topView) {
        self.topView = [UIView new];
        [self.view addSubview:self.topView];
        self.topView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .topEqualToView(self.view)
        .heightIs(42)
        ;
        [self.topView updateLayout];
        
        self.topView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
            
            if (UserGetBool(@"NightMode")) {
                [(UIView *)item addBorderTo:BorderTypeBottom borderColor:CutLineColorNight];
            }else{
                [(UIView *)item addBorderTo:BorderTypeBottom borderColor:CutLineColor];
            }
        });
        //添加下阴影
//        self.topView.layer.shadowColor = GrayColor.CGColor;
//        self.topView.layer.shadowOffset = CGSizeMake(-2, 2);
//        self.topView.layer.shadowOpacity = 0.5;
//        self.topView.layer.shouldRasterize = NO;
//        self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topView.bounds].CGPath;
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40) titles:[self getTitlesArrFromArr:self.titleList] headStyle:1 layoutStyle:2];
    
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.4;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    
//    _segHead.selectColor = HexColor(#5A5A5A);
    
    _segHead.deSelectColor = HexColor(#5A5A5A);
    _segHead.maxTitles = 7;
    _segHead.bottomLineHeight = 0;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame) + 5, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame) - NAVI_HEIGHT - TAB_HEIGHT - 5) vcOrViews:[self getvcArr]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.topView addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    [_segHead.titlesScroll addBakcgroundColorTheme];
    _segHead.getLineView.layer.cornerRadius = 2.0f;
    
    _segHead.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        [(MLMSegmentHead *)item setSelectColor:value];
    });
    
    //添加更多按钮
    if (_moreBtn) {
        [_moreBtn removeFromSuperview];
    }
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_segHead.frame), CGRectGetMinY(_segHead.frame), 40, 40)];
    
    [_moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.lee_theme.LeeConfigBackgroundColor(@"backgroundColor");
    [self.topView addSubview:_moreBtn];
    
//    _moreBtn.sd_layout
//    .rightEqualToView(self.view)
//    .topEqualToView(self.view)
//    .widthIs(40)
//    .heightIs(40)
//    ;
//    [_moreBtn setImage:UIImageNamed(@"manageMenu") forState:UIControlStateNormal];
    _moreBtn.lee_theme.LeeConfigButtonImage(@"homePage_manageMenu", UIControlStateNormal);
    _moreBtn.lee_theme.LeeConfigButtonImage(@"homePage_manageMenu_selected", UIControlStateSelected);
    _moreBtn.selected = UserGetBool(@"NewAttentionChannel");
}

//全部频道
-(void)more:(UIButton *)btn
{
    //点击一次后，取消红点提示
    UserSetBool(NO, @"NewAttentionChannel");
    btn.selected = NO;
    @weakify(self)
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:self.titleList unUseTitles:self.leaveTitleList finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        @strongify(self)
        GGLog(@"返回标题数组");
        //看是否并没有改变数组
        if ([NSArray compareArr:[self getTitlesArrFromArr:inUseTitles] andArr2:[self getTitlesArrFromArr:self.titleList]]) {
            
        }else{
            self.titleList = [inUseTitles mutableCopy];
            [self reloadChildVCWithTitles:self.titleList];
            self.leaveTitleList = [unUseTitles mutableCopy];
            //目前不需要设置用户的频道了
//            [self requestUserAttentionChannels];
            [self saveColumnArr];
        }
        
    } click:^(NSString *title) {
        @strongify(self)
        GGLog(@"返回单个点击");
        NSInteger index = [self.titleList indexOfObject:title];
        [self.segHead changeIndex:index completion:YES];
    }];
}

- (NSArray *)getvcArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titleList.count; i ++) {
        HomePageChildVCViewController *vc = [HomePageChildVCViewController new];
        XLChannelModel *model = self.titleList[i];
        vc.news_id = model.channelId;
        vc.channel_name = model.channelName;
        [arr addObject:vc];
    }
    return arr;
}


//将title分离出一个数组
-(NSArray *)getTitlesArrFromArr:(NSArray *)arr
{
    NSMutableArray *titleArr = [NSMutableArray new];
    for (XLChannelModel *model in arr) {
        [titleArr addObject:model.channelName];
    }
    return titleArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ---- 请求相关
//请求栏目列表
-(void)requestChnanel:(BOOL)compare
{
    [HttpRequest getWithURLString:Channel_listChannels parameters:nil success:^(id responseObject) {
        NSArray *channelConcerned = [XLChannelModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"concerned"]];
        NSArray *channelUnconcerned = [XLChannelModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"unconcerned"]];
        
        if (compare) {
            //比对数据
            [UniversalMethod compareChannels:[channelConcerned arrayByAddingObjectsFromArray:channelUnconcerned] reasonAction:^(BOOL changed1 ,BOOL changed2, NSArray *attentionArr, NSArray *unAttentionArr) {
                //拿到了比对后的数据，根据情况判断是否要更新本地缓存
                //如果本地没有缓存
                if (changed1 == YES &&changed2 == YES &&!attentionArr.count&&!unAttentionArr.count) {
                    if (!kArrayIsEmpty(channelConcerned)) {
                        self.titleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelConcerned]];
                    }
                    if (!kArrayIsEmpty(channelUnconcerned)) {
                        self.leaveTitleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelUnconcerned]];
                    }
                    //这里暂时不做新数据提醒
                    [self reloadChildVCWithTitles:self.titleList];
                }else{
                    if (changed1) {
                        self.titleList = [attentionArr mutableCopy];
                        [self reloadChildVCWithTitles:self.titleList];
                    }
                    if (changed2) {
                        self.leaveTitleList = [unAttentionArr mutableCopy];
                        //此处需要提醒用户有频道更新
                        LRToast(@"未关注频道有更新哦");
                        self.moreBtn.selected = YES;
                        UserSetBool(YES, @"NewAttentionChannel");
                    }
                    
                }
                //存储数据到本地
                [self saveColumnArr];
            }];
        }else{
            if (!kArrayIsEmpty(channelConcerned)) {
                self.titleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelConcerned]];
            }
            if (!kArrayIsEmpty(channelUnconcerned)) {
                self.leaveTitleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelUnconcerned]];
            }
            //存储数据到本地
            [self saveColumnArr];
            
            [self reloadChildVCWithTitles:self.titleList];
        }
    } failure:nil];
}

//比对2个频道数组是否不同
-(BOOL)compareArr1:(NSArray *)arr1 arr2:(NSArray *)arr2
{
    BOOL isEqual = NO;
    if (arr1.count == arr2.count) {
        for (int i = 0; i<arr1.count; i ++) {
            XLChannelModel *model = arr1[i];
            isEqual = NO;
            for (XLChannelModel *model2 in arr2) {
                if ([model.channelId isEqualToString:model2.channelId]) {
                    isEqual = YES;
                    break;
                }
            }
        }
    }
    return isEqual;
}

//保存栏目设置到本地
-(void)saveColumnArr
{
    [NSArray bg_clearArrayWithName:@"columnArr"];
    NSMutableArray* columnArr = [NSMutableArray array];
    [columnArr addObject:self.titleList];
    [columnArr addObject:self.leaveTitleList];
    [columnArr bg_saveArrayWithName:@"columnArr"];
}

//设置用户的频道管理
-(void)requestUserAttentionChannels
{
    NSMutableArray *array = [NSMutableArray new];
    for (XLChannelModel *model in self.titleList) {
        if (model.status != 2) {
           [array addObject:model.channelId];
        }
    }
    if (array.count<=0) {
        LRToast(@"没有关注更多频道");
        return;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [HttpRequest postWithURLString:SetConcernedChannels parameters:@{@"channelIds":jsonString} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        LRToast(@"频道已设置完毕");
    } failure:nil RefreshAction:nil];
}

//首页广告弹框
-(void)requestADPop
{
    [RequestGather requestBannerWithADId:4 success:^(id response) {
        NSArray *popArr = response;
        if (popArr.count>0) {
            [ADPopView showWithData:[popArr firstObject]];
        }
    } failure:nil];
}

//获取用户未读消息数量
-(void)requestGetCountOfUnreadMessage
{
    [HttpRequest getWithURLString:GetCountOfUnreadMessage parameters:nil success:^(id responseObject) {
        MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
        //获取指定item
        UITabBarItem *item = [keyVC.tabBar.items lastObject];
        NSInteger count = [responseObject[@"data"][@"count"] integerValue];
        if (count) {
            UserSetBool(YES, @"MessageNotice");
            item.badgeValue = @"5";
        }else{
            UserSetBool(NO, @"MessageNotice");
            item.badgeValue = nil;
        }
    } failure:nil];
}

@end
