//
//  BaseNavigationVC.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BaseNavigationVC.h"

@interface BaseNavigationVC ()

@property (nonatomic, weak) UIImageView *lineView;
@end

@implementation BaseNavigationVC
-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [self getLineViewInNavigationBar:self.navigationBar];
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏不透明
    [UINavigationBar appearance].translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    @weakify(self)
    self.navigationBar.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
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
        [self.navigationBar setTitleTextAttributes:dic];
    });
    
    //统一设置navigationBar的样式
    //    self.navigationBar.barTintColor = RedColor;
//    self.navigationBar.lee_theme.LeeConfigBarTintColor(@"backgroundColor");
}

//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

/**
 显示导航栏下的横线
 */
-(void)showNavigationDownLine
{
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:RGBA(227, 227, 227, 1)] forBarMetrics:UIBarMetricsDefault];
    //
    //    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:RGBA(227, 227, 227, 1)]];
    self.lineView.hidden = NO;
}


/**
 去除导航栏横线
 */
-(void)hideNavigationDownLine
{
    //    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    //
    //    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
    self.lineView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


//重写这个方法的目的是为了拦截所有push进来的控制器
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //判断如果是不是首页控制器 然后统一设置
    if (self.childViewControllers.count > 0) {
        
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置左边按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"return_left" hightimage:@"return_left" andTitle:@""];
        
        //设置右边按钮
        
        
    }else{
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
    
}

//如果点击左边按钮就返回上级页面
-(void)back{
    
    [self popViewControllerAnimated:YES];
    
}

//设置右边按钮点击事件直接跳转到根控制器
-(void)more{
    
    [self popToRootViewControllerAnimated:YES];
    
}





@end


