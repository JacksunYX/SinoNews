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
        _titleList = [NSMutableArray arrayWithObjects:
                      @"最新",
                      @"视频",
                      @"游戏",
                      @"娱乐",
                      @"测试一下",
                      @"体育",
                      @"电子",
                      
                      nil];
        
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
    
    [self addNavigationView];
    
    [self reloadChildVCWithTitles:self.titleList];
    
}

//修改导航栏显示
-(void)addNavigationView
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 34)];
    
    self.searchBar.placeholder = @"热门搜索";
    
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            textField.backgroundColor = HexColor(#EEEEEE);
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 17.0f;
            textField.layer.borderColor = HexColor(#EEEEEE).CGColor;
            textField.layer.borderWidth = 1;
            //设置输入字体颜色
            textField.textColor = BlueColor;
            //设置默认文字颜色
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 热门搜索" attributes:@{NSForegroundColorAttributeName:HexColor(#AEAEAE)}];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            tap.numberOfTapsRequired = 1;
            [textField addGestureRecognizer:tap];
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            //            UIButton *cancel = (UIButton *)view;
            //            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            
        }
    }
    
    
    
    self.navigationItem.titleView = self.searchBar;
    
    _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    _userIcon.backgroundColor = GrayColor;
    LRViewBorderRadius(_userIcon, 17, 0, HexColor(#B5B5B5));
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_userIcon];
    
}

//设置下方分页联动
-(void)reloadChildVCWithTitles:(NSArray *)titles
{
    self.titleList = [titles mutableCopy];
    if (_segHead) {
        [_segHead removeFromSuperview];
    }
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 40) titles:self.titleList headStyle:1 layoutStyle:2];
    //    _segHead.fontScale = .85;
    _segHead.lineScale = 0.8;
    _segHead.fontSize = 16;
    _segHead.lineHeight = 3;
    _segHead.lineColor = HexColor(#1282EE);
    _segHead.selectColor = HexColor(#1282EE);
    _segHead.deSelectColor = HexColor(#7B7B7B);
    _segHead.maxTitles = 7;
    _segHead.bottomLineHeight = 0;
    
    if (_segScroll) {
        [_segScroll removeFromSuperview];
    }
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame) - NAVI_HEIGHT - TAB_HEIGHT) vcOrViews:[self vcArr:self.titleList.count]];
    _segScroll.countLimit = 0;
    
    WEAK(weakself, self);
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [weakself.view addSubview:weakself.segHead];
        [weakself.view addSubview:weakself.segScroll];
    }];
    
    //添加更多按钮
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    
    [moreBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:moreBtn];
    
    [moreBtn activateConstraints:^{
        moreBtn.right_attr = weakself.view.right_attr_safe;
        moreBtn.top_attr = weakself.view.top_attr_safe;
        moreBtn.width_attr.constant = 40;
        moreBtn.height_attr.constant = 40;
    }];
    [moreBtn setImage:UIImageNamed(@"manageMenu") forState:UIControlStateNormal];
}

//全部频道
-(void)more:(UIButton *)btn
{
    WeakSelf
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:self.titleList unUseTitles:self.leaveTitleList finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        GGLog(@"返回标题数组");
        //看是否并没有改变数组
        if ([NSArray compareArr:inUseTitles another:self.titleList]) {
            
        }else{
            weakSelf.titleList = [inUseTitles mutableCopy];
            [weakSelf reloadChildVCWithTitles:inUseTitles];
            weakSelf.leaveTitleList = [unUseTitles mutableCopy];
        }
        
    } click:^(NSString *title) {
        GGLog(@"返回单个点击");
        NSInteger index = [weakSelf.titleList indexOfObject:title];
        [weakSelf.segHead changeIndex:index completion:YES];
        
    }];
}

- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        HomePageChildVCViewController *vc = [HomePageChildVCViewController new];
//        vc.index = i;
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}






@end
