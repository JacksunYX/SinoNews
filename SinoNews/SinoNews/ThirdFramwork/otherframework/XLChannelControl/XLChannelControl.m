//
//  XLChannelControl.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelControl.h"
#import "XLChannelView.h"

@interface XLChannelControl ()
{
    UINavigationController *_nav;
    
    XLChannelView *_channelView;
    
    ChannelBlock _block;
    
    
}

@property (nonatomic,copy) ClickHandle clickBlock;
@end

@implementation XLChannelControl

+(XLChannelControl*)shareControl{
    static XLChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[XLChannelControl alloc] init];
    });
    return control;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

-(void)buildChannelView{
    
    _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    __weak typeof(self) weakSelf = self;
    [_channelView addBakcgroundColorTheme];
    _channelView.clickBlock = ^(NSString *clickTitle) {
//        [weakSelf popView];
        [weakSelf backMethod];
        weakSelf.clickBlock(clickTitle);
    };
    
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    //设置不同模式下的样式
    @weakify(self)
    _nav.navigationBar.lee_theme.LeeCustomConfig(@"navigationBarColor", ^(id item, id value) {
        @strongify(self)
        UINavigationBar *naviBar = (UINavigationBar *)item;
        //导航栏背景色
        naviBar.barTintColor = value;
        //标题颜色
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[NSFontAttributeName] = PFFontL(16);
        
        if (UserGetBool(@"NightMode")) {
            naviBar.tintColor = HexColor(#CFD3D6);
            dic[NSForegroundColorAttributeName] = HexColor(#CFD3D6);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
            self->_nav.topViewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(backMethod) image:@"saerchClose_night" hightimage:nil andTitle:@""];
        }else{
            naviBar.tintColor = HexColor(#000000);
            dic[NSForegroundColorAttributeName] = HexColor(#323232);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
            self->_nav.topViewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(backMethod) image:@"saerchClose" hightimage:nil andTitle:@""];
        }
        [naviBar setTitleTextAttributes:dic];
    });
    
    _nav.topViewController.title = @"全部频道";
    _nav.topViewController.view = _channelView;
//    UIBarButtonItem *item = [UIBarButtonItem fixedSpaceWithWidth:10];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
//    _nav.topViewController.navigationItem.rightBarButtonItems = @[item,item2];
}

-(void)backMethod
{
    [self popView];
    _block(_channelView.inUseTitles,_channelView.unUseTitles);
}

-(void)popView
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self->_nav.view.frame;
        frame.origin.y = - self->_nav.view.bounds.size.height;
        self->_nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [self->_nav.view removeFromSuperview];
    }];
}

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChannelBlock)block click:(ClickHandle)clickBlock
{
    _block = block;
    _clickBlock = clickBlock;
    _channelView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _channelView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_channelView reloadData];

    CGRect frame = _nav.view.frame;
    frame.origin.y = - _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        self->_nav.view.alpha = 1;
        self->_nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}

@end
