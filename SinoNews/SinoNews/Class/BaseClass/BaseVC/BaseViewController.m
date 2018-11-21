//
//  BaseViewController.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)dealloc
{
    GGLog(@"%@释放了",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
            //设置夜间模式的状态栏
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"return_left_night" hightimage:@"return_left_night" andTitle:@""];
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left_night"]];
        }else{
            dic[NSForegroundColorAttributeName] = HexColor(#323232);
            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
//            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"return_left" hightimage:@"return_left" andTitle:@""];
            self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:[UIImage imageNamed:@"return_left"]];
        }
        [self.navigationController.navigationBar setTitleTextAttributes:dic];
    });
    //使用系统的返回键
    self.rt_navigationController.useSystemBackBarButtonItem = YES;
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
