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
#import "SearchViewController.h"    //搜索页面

@interface HomePageViewController ()

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *titleList;
@property (nonatomic, strong) NSMutableArray *leaveTitleList;
@property (nonatomic, strong) UIImageView *userIcon;
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
    
    self.view.backgroundColor = WhiteColor;
    
    [self showOrHideLoadView:YES page:1];
    
    [self addNavigationView];
    
//    NSArray* columnArr = [NSArray bg_arrayWithName:@"columnArr"];
//    if (kArrayIsEmpty(columnArr)) {
        [self requestChnanel];
//    }else{
//        self.titleList = [NSMutableArray arrayWithArray:columnArr[0]];
//        [self reloadChildVCWithTitles:self.titleList];
//        self.leaveTitleList = columnArr[1];
//    }
}

//修改导航栏显示
-(void)addNavigationView
{
    //需要把searchbar作为导航栏的titleview时，不要直接设置，因为直接创建的searchbar高度时固定为44的，这样会把导航栏的高度撑高，不再是44，可以使用下面的方法来创建
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * ScaleW, 34)];
    self.searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
    self.searchBar.placeholder = @"热门搜索";
    // 设置搜索框放大镜图标
    UIImage *searchIcon = UIImageNamed(@"searchBar_icon");
    [self.searchBar setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            textField.backgroundColor = HexColor(#F1F1F1);
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 17.0f;
            textField.layer.borderColor = HexColor(#F1F1F1).CGColor;
            textField.layer.borderWidth = 1;
            //设置输入字体颜色
            textField.textColor = BlueColor;
            //设置默认文字颜色
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 搜个关键词试试看？" attributes:@{
                                                                                                                    NSForegroundColorAttributeName:HexColor(#E1E1E1),
                                                                                                                    NSFontAttributeName:Font(13),
                                                                                                                    }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.numberOfTapsRequired = 1;
            [textField addGestureRecognizer:tap];
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            //            UIButton *cancel = (UIButton *)view;
            //            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            
        }
    }
    
    _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _userIcon.backgroundColor = GrayColor;
    LRViewBorderRadius(_userIcon, 15, 0, HexColor(#B5B5B5));
    _userIcon.image = UIImageNamed(@"logo_test");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_userIcon];
    
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    [self showOrHideLoadView:NO page:1];
    self.titleList = [titles mutableCopy];
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40) titles:[self getTitlesArrFromArr:self.titleList] headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.5;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#5A5A5A);
    _segHead.deSelectColor = HexColor(#5A5A5A);
    _segHead.maxTitles = 7;
    _segHead.bottomLineHeight = 0;
    //添加下阴影
    _segHead.layer.shadowColor = GrayColor.CGColor;
    _segHead.layer.shadowOffset = CGSizeMake(-2, 2);
    _segHead.layer.shadowOpacity = 0.5;
    _segHead.layer.shouldRasterize = NO;
    _segHead.layer.shadowPath = [UIBezierPath bezierPathWithRect:_segHead.bounds].CGPath;
//    _segHead.layer.shadowRadius = 1;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame) + 5, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame) - NAVI_HEIGHT - TAB_HEIGHT - 5) vcOrViews:[self getvcArr]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.view addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    
    //添加更多按钮
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    
    [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setBackgroundColor:WhiteColor];
    [self.view addSubview:moreBtn];
    
    [moreBtn activateConstraints:^{
        moreBtn.right_attr = weakself.view.right_attr_safe;
        moreBtn.top_attr = weakself.view.top_attr_safe;
        moreBtn.width_attr.constant = 40;
        moreBtn.height_attr.constant = 40;
    }];
    [moreBtn setImage:UIImageNamed(@"manageMenu") forState:UIControlStateNormal];
    moreBtn.layer.shadowColor = GrayColor.CGColor;
    moreBtn.layer.shadowOffset = CGSizeMake(-1, 2);
    moreBtn.layer.shadowOpacity = 0.5;
    moreBtn.layer.shouldRasterize = NO;
    moreBtn.layer.shadowPath = [UIBezierPath bezierPathWithRect:moreBtn.bounds].CGPath;
}

//全部频道
-(void)more:(UIButton *)btn
{
    
    WeakSelf
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:self.titleList unUseTitles:self.leaveTitleList finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        GGLog(@"返回标题数组");
        //看是否并没有改变数组
        if ([NSArray compareArr:[self getTitlesArrFromArr:inUseTitles] andArr2:[self getTitlesArrFromArr:self.titleList]]) {

        }else{
            weakSelf.titleList = [inUseTitles mutableCopy];
            [weakSelf reloadChildVCWithTitles:weakSelf.titleList];
            weakSelf.leaveTitleList = [unUseTitles mutableCopy];
            [weakSelf saveColumnArr];
        }

    } click:^(NSString *title) {
        GGLog(@"返回单个点击");
        NSInteger index = [weakSelf.titleList indexOfObject:title];
        [weakSelf.segHead changeIndex:index completion:YES];
    }];
}

- (NSArray *)getvcArr
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titleList.count; i ++) {
        HomePageChildVCViewController *vc = [HomePageChildVCViewController new];
        XLChannelModel *model = self.titleList[i];
        vc.news_id = model.channelId;
        [arr addObject:vc];
    }
    return arr;
}

-(void)tap:(UITapGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
    SearchViewController *sVC = [SearchViewController new];
    [self.navigationController pushViewController:sVC animated:NO];
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
-(void)requestChnanel
{
    [HttpRequest getWithURLString:Channel_listChannels parameters:nil success:^(id responseObject) {
        NSArray *channelConcerned = responseObject[@"data"][@"concerned"];
        NSArray *channelUnconcerned = responseObject[@"data"][@"unconcerned"];
        if (!kArrayIsEmpty(channelConcerned)) {
            self.titleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelConcerned]];
        }
        if (!kArrayIsEmpty(channelUnconcerned)) {
            self.leaveTitleList = [NSMutableArray arrayWithArray:[XLChannelModel mj_objectArrayWithKeyValuesArray:channelUnconcerned]];
        }
        //存储数据
//        [self saveColumnArr];
        
        [self reloadChildVCWithTitles:self.titleList];
        
    } failure:nil];
}

//保存栏目设置
-(void)saveColumnArr
{
    [NSArray bg_clearArrayWithName:@"columnArr"];
    NSMutableArray* columnArr = [NSMutableArray array];
    [columnArr addObject:self.titleList];
    [columnArr addObject:self.leaveTitleList];
    [columnArr bg_saveArrayWithName:@"columnArr"];
}


@end
