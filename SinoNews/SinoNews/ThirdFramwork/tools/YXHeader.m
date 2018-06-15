//
//  YXHeader.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXHeader.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation YXHeader
+ (BOOL)checkLogin
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        return YES;
    } else {
        [[HttpRequest getCurrentVC] presentViewController:[[BaseNavigationVC alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.isLogin) {
        return YES;
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.normalBack = YES;
        [[HttpRequest getCurrentVC] presentViewController:[[BaseNavigationVC alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
        return NO;
    }
}

@end
