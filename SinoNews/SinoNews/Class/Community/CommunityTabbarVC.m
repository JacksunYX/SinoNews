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
{
    NSInteger lastSelectIndex;
}
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
            //特别要注意的是:top和bottom要设置成相反数，不然image的大小会一直改变
            navi.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
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
    lastSelectIndex = 0;
}

//拦截点击事件
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    lastSelectIndex = self.selectedIndex;
    NSInteger currentIndex = [self.viewControllers indexOfObject:viewController];
//    GGLog(@"当前点击的下标:%ld",currentIndex);
    if (viewController == self.viewControllers[1]) {
        if ([YXHeader checkLogin]) {
            [self presentViewController:[[RTRootNavigationController alloc]initWithRootViewController:[EditSelectViewController new]] animated:YES completion:nil];
        }
        return NO;
    }else if (lastSelectIndex == 2&&currentIndex==2){
        [kNotificationCenter postNotificationName:RefreshReadPost object:nil];
    }
    return  YES;
}

@end
