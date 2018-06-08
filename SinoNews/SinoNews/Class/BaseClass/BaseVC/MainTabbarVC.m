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

#import "BaseNavigationVC.h"

@interface MainTabbarVC ()

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
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:tabTitles[i] image:UIImageNamed(tabImgUnselect[i]) selectedImage:UIImageNamed(tabImgSelected[i])];
        navi.tabBarItem = item;
//        navi.tabBarItem.title = tabTitles[i];
//        navi.tabBarItem.image = UIImageNamed(tabImgUnselect[i]);
        
        [vcsArr addObject:navi];
    }
    
    self.viewControllers = vcsArr;
    self.selectedIndex = 0;
}





@end
