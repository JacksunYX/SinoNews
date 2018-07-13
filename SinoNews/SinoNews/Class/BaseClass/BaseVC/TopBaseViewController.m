//
//  TopBaseViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "TopBaseViewController.h"

@interface TopBaseViewController ()

@end

@implementation TopBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏不透明
    [UINavigationBar appearance].translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    @weakify(self)
    self.view.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        @strongify(self)
        self.view.backgroundColor = value;
        self.navigationController.navigationBar.barTintColor = value;
    });
    
    self.view.lee_theme.LeeCustomConfig(@"navigationBarColor", ^(id item, id value) {
        @strongify(self)
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[NSFontAttributeName] = PFFontL(16);
        if (UserGetBool(@"NightMode")) {
            dic[NSForegroundColorAttributeName] = HexColor(#FFFFFF);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
        }else{
            dic[NSForegroundColorAttributeName] = HexColor(#323232);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
        }
        [self.navigationController.navigationBar setTitleTextAttributes:dic];
    });
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
