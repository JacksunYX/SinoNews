//
//  CommunityTabbarVC.m
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "CommunityTabbarVC.h"

#import "ForumViewController.h"
#import "EditSelectViewController.h"
#import "ReadThePostMainVC.h"

@interface CommunityTabbarVC ()<UITabBarControllerDelegate>

@end

@implementation CommunityTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addBakcgroundColorTheme];
    self.delegate = self;
    [self addChildVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addChildVC
{
    NSArray *tabTitles = @[
                           @"版块",
                           @"",
                           @"读帖",
                           ];
    
    NSArray *vcs = @[
                     [ForumViewController new],
                     [UIViewController new],
                     [ReadThePostMainVC new],
                     ];
    
    NSArray *tabImgUnselect = @[
                                @"tabbar_section",
                                @"tabbar_forumPost",
                                @"tabbar_thread",
                                ];
    NSArray *tabImgSelected = @[
                                @"tabbar_section_selected",
                                @"tabbar_forumPost",
                                @"tabbar_thread_selected",
                                ];
    
    NSMutableArray *vcsArr = [NSMutableArray new];
    for (int i = 0; i < vcs.count; i ++) {
        
        RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:vcs[i]];
        
        
        navi.tabBarItem.image = [UIImageNamed(tabImgUnselect[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navi.tabBarItem.selectedImage = [UIImageNamed(tabImgSelected[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (i==1) {
            navi.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, -10, 0);
        }else{
            navi.tabBarItem.title = tabTitles[i];
        }
        [vcsArr addObject:navi];
    }
    
//    @weakify(self)
//    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
//        @strongify(self)
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:HexColor(#FFFFFF)]];
        [self.tabBar setShadowImage:[UIImage imageWithColor:HexColor(#F2F2F2)]];
//        if (UserGetBool(@"NightMode")) {
//            [self.tabBar setBackgroundImage:[UIImage imageWithColor:HexColor(#1c2023)]];
//            [self.tabBar setShadowImage:[UIImage imageWithColor:CutLineColorNight]];
//        }
//    });
    self.viewControllers = vcsArr;
    self.selectedIndex = 0;
}

//拦截点击事件
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if (viewController == self.viewControllers[1]) {
        [self presentViewController:[[RTRootNavigationController alloc]initWithRootViewController:[EditSelectViewController new]] animated:YES completion:nil];
        return NO;
    }
    return  YES;
}

@end
