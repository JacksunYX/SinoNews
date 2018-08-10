//
//  UserModel.m
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

MJCodingImplementation

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{};
}

+(void)clearLocalData
{
    UserSet(@"", @"isLogin")
    UserSet(@"", @"token")
    UserSet(@"", @"avatar")
    UserSet(@"", @"username")
    [UserModel bg_clear:nil];
//    [NSArray bg_clearArrayWithName:@"columnArr"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginOutNotify object:nil];
    GGLog(@"本地用户信息已清除");
}

+(UserModel *)getLocalUserModel
{
    UserModel *user;
    NSArray* findAlls = [UserModel bg_findAll:nil];
    if (!kArrayIsEmpty(findAlls)) {
        user = [findAlls firstObject];
    }
    return user;
}

+(void)coverUserData:(UserModel *)data
{
    if ([data bg_cover]) {
        GGLog(@"用户本地数据已被覆盖至最新");
    }
}

//根据userId来判断跳转到哪个界面
+(void)toUserInforVcOrMine:(NSInteger)userId
{
    UserModel *user = [self getLocalUserModel];
    UIViewController *currentVC = [HttpRequest currentViewController];
    if (user.userId == userId) {
        //如果是用户本人发的文章，直接跳到我的界面
        [currentVC.navigationController popViewControllerAnimated:NO];
        UITabBarController *tabbarVC = (UITabBarController *)[HttpRequest getCurrentVC];
        [tabbarVC setSelectedIndex:4];
    }else{
        UserInfoViewController *uiVC = [UserInfoViewController new];
        uiVC.userId = userId;
        [currentVC.navigationController pushViewController:uiVC animated:YES];
    }
}

//是否需要显示关注按钮
+(BOOL)showAttention:(NSInteger)userId
{
    UserModel *user = [self getLocalUserModel];
    if (user.userId == userId) {
        return NO;
    }
    return YES;
}





@end
