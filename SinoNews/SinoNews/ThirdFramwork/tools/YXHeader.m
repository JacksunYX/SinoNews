//
//  YXHeader.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "YXHeader.h"
#import "LoginViewController.h"

@implementation YXHeader
+ (BOOL)checkLogin
{
    if ([UserGet(@"isLogin") isEqualToString:@"YES"]) {
        return YES;
    } else {
        [[HttpRequest getCurrentVC] presentViewController:[[RTRootNavigationController alloc] initWithRootViewController:[LoginViewController new]] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin
{
    if ([UserGet(@"isLogin") isEqualToString:@"YES"]) {
        return YES;
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.normalBack = YES;
        [[HttpRequest getCurrentVC] presentViewController:[[RTRootNavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
        return NO;
    }
}

//新增一个带回调的登录检测
+ (BOOL)checkNormalBackLoginHandle:(void (^)(BOOL login))backHandle
{
    if ([UserGet(@"isLogin") isEqualToString:@"YES"]) {
        return YES;
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        loginVC.normalBack = YES;
        loginVC.backHandleBlock = ^(BOOL login) {
            if (backHandle) {
                backHandle(login);
            }
        };
        [[HttpRequest currentViewController] presentViewController:[[RTRootNavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

//登录成功，保存数据
+(void)loginSuccessSaveWithData:(NSDictionary *)response
{
    UserSet(@"YES", @"isLogin");
//    UserSet(GetSaveString(response[@"data"][@"avatar"]), @"avatar");
//    UserSet(GetSaveString(response[@"data"][@"username"]), @"username");
    UserSet(GetSaveString(response[@"data"][@"token"]), @"token");
    UserModel *user = [UserModel mj_objectWithKeyValues:response[@"data"]];
    //注册通知别名
    [CoreJPush setTags:nil alias:[NSString stringWithFormat:@"%ld",user.userId] resBlock:^(BOOL res, NSSet *tags, NSString *alias) {
        if(res){
            GGLog(@"注册别名成功：%@,%@",tags,alias);
        }else{
            GGLog(@"注册别名失败");
        }
    }];
    [UserModel coverUserData:user];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginSuccess object:nil];
}


@end
