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
#import "CommunityTabbarVC.h"

#import <AudioToolbox/AudioToolbox.h>


@interface MainTabbarVC ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger  indexFlag;

@end

@implementation MainTabbarVC

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
                           @"主页",
                           @"社区",
                           @"关注",
                           @"排行榜",
//                           @"积分",
                           @"我的",
                           ];
    
    NSArray *vcs = @[
                     [HomePageViewController new],
                     [UIViewController new],
                     [AttentionViewController new],
                     [RankViewController new],
//                     [IntegralViewController new],
                     [MineViewController new],
                     
                     ];
    
    NSArray *tabImgUnselect = @[
                                @"homepage_unselect",
                                @"integral_unselect",
                                @"attention_unselect",
                                @"rankinglist_unselect",
                                
                                @"mine_unselect",
                                ];
    NSArray *tabImgSelected = @[
                                @"homepage_selected",
                                @"integral_selected",
                                @"attention_selected",
                                @"rankinglist_selected",
                                
                                @"mine_selected",
                                ];
    
    NSMutableArray *vcsArr = [NSMutableArray new];
    for (int i = 0; i < vcs.count; i ++) {
        
        RTRootNavigationController *navi = [[RTRootNavigationController alloc]initWithRootViewController:vcs[i]];
        navi.lee_theme.LeeCustomConfig(@"tabbarColor", ^(id item, id value) {
//            GGLog(@"进入了");
            NSString *imgStr = tabImgUnselect[i];
            if (UserGetBool(@"NightMode")) {
                imgStr = [imgStr stringByAppendingString:@"_night"];
            }
            [[(RTRootNavigationController *)item tabBarItem] setImage:[UIImageNamed(imgStr) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        });
//        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:tabTitles[i] image:[UIImageNamed(tabImgUnselect[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageNamed(tabImgSelected[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        navi.tabBarItem = item;
        navi.tabBarItem.title = tabTitles[i];
//        navi.tabBarItem.image = [UIImageNamed(tabImgUnselect[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navi.tabBarItem.selectedImage = [UIImageNamed(tabImgSelected[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vcsArr addObject:navi];
    }
//    [UINavigationBar appearance].lee_theme.LeeConfigBarTintColor(@"backgroundColor");
//    [UITabBar appearance].lee_theme.LeeConfigBarTintColor(@"backgroundColor");
    @weakify(self)
    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        [self.tabBar setBackgroundImage:[UIImage imageWithColor:HexColor(#FFFFFF)]];
        [self.tabBar setShadowImage:[UIImage imageWithColor:HexColor(#F2F2F2)]];
        if (UserGetBool(@"NightMode")) {
            [self.tabBar setBackgroundImage:[UIImage imageWithColor:HexColor(#1c2023)]];
            [self.tabBar setShadowImage:[UIImage imageWithColor:CutLineColorNight]];
        }
    });
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
        //点击音效
        [self playSound];
        
        self.indexFlag = index;
    }
    
    if (index==2) {
        [YXHeader checkNormalBackLoginHandle:^(BOOL login) {
            if (login) {
                
            }else{
                [self setSelectedIndex:0];
            }
        }];
    }
    
}

//拦截点击事件
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if (viewController ==self.viewControllers[1] ) {
        [self presentViewController:[CommunityTabbarVC new] animated:NO completion:nil];
        return NO;
    }
    return  YES;
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

//点击音效
-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tabbarClick2" ofType:@"mp3"];
    SystemSoundID soundID;
    if (path) {
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&soundID);
        AudioServicesPlaySystemSound(soundID);
    }else{
        GGLog(@"无效的音频文件");
    }
}


@end
