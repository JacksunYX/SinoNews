//
//  MainTabbarVC.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MainTabbarVC.h"

#import "HomePageViewController.h"
#import "AttentionViewController.h"
#import "RankViewController.h"
#import "IntegralViewController.h"
#import "MineViewController.h"


@interface MainTabbarVC ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger  indexFlag;

@end

@implementation MainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addChildVC
{
    
    NSArray *tabTitles = @[
                           @"主页",
                           @"关注",
                           @"排行榜",
                           @"积分",
                           @"我的",
                           ];
    
    NSArray *vcs = @[
                     [HomePageViewController new],
                     [AttentionViewController new],
                     [RankViewController new],
                     [IntegralViewController new],
                     [MineViewController new],
                     
                     ];
    
    NSArray *tabImgUnselect = @[
                                @"homepage_unselect",
                                @"attention_unselect",
                                @"rankinglist_unselect",
                                @"integral_unselect",
                                @"mine_unselect",
                                ];
    NSArray *tabImgSelected = @[
                                @"homepage_selected",
                                @"attention_selected",
                                @"rankinglist_selected",
                                @"integral_selected",
                                @"mine_selected",
                                ];
    
    NSMutableArray *vcsArr = [NSMutableArray new];
    for (int i = 0; i < vcs.count; i ++) {
        BaseNavigationVC *navi = [[BaseNavigationVC alloc]initWithRootViewController:vcs[i]];
        
//        navi.lee_theme.LeeCustomConfig(@"navigationBarColor", ^(id item, id value) {
//            [(BaseNavigationVC *)item navigationBar].tintColor = HexColor(value);
//        });
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:tabTitles[i] image:[UIImageNamed(tabImgUnselect[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageNamed(tabImgSelected[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        navi.tabBarItem = item;
//        navi.tabBarItem.title = tabTitles[i];
//        navi.tabBarItem.image = UIImageNamed(tabImgUnselect[i]);
        
        [vcsArr addObject:navi];
    }
//    [UINavigationBar appearance].lee_theme.LeeConfigBarTintColor(@"backgroundColor");
    [UITabBar appearance].lee_theme.LeeConfigBarTintColor(@"backgroundColor");
    self.viewControllers = vcsArr;
    self.selectedIndex = 0;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //添加动画
        [self addAnimationOnLayer:[arry[index] layer]];
        
        self.indexFlag = index;
    }
}

-(void)addAnimationOnLayer:(CALayer *)layer
{
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.1;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:1.1];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.0];     //结束伸缩倍数
    [layer addAnimation:animation forKey:nil];
}


@end
