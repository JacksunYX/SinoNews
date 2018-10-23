//
//  Base2ViewController.m
//  SinoNews
//
//  Created by Michael on 2018/7/17.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "Base2ViewController.h"

@interface Base2ViewController ()

@end

@implementation Base2ViewController
-(void)dealloc
{
    GGLog(@"%@释放了",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏不透明
//    [UINavigationBar appearance].translucent = YES;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addBakcgroundColorTheme];
    @weakify(self);
    self.view.lee_theme.LeeCustomConfig(@"navigationBarColor", ^(id item, id value) {
        @strongify(self)
        NSMutableDictionary *dic = [NSMutableDictionary new];
        dic[NSFontAttributeName] = PFFontL(16);
        if (UserGetBool(@"NightMode")) {
            dic[NSForegroundColorAttributeName] = HexColor(#FFFFFF);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"return_left_night" hightimage:@"return_left_night" andTitle:@""];
            
        }else{
            dic[NSForegroundColorAttributeName] = HexColor(#323232);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"return_left" hightimage:@"return_left" andTitle:@""];
            
        }
        [self.navigationController.navigationBar setTitleTextAttributes:dic];
    });
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
