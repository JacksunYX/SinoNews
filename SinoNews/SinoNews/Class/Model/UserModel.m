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
    if ([self getLocalUserModel]) {
        UserSet(@"", @"isLogin")
        UserSet(@"", @"token")
        UserSet(@"", @"avatar")
        UserSet(@"", @"username")
        [UserModel bg_clear:nil];
        //清除通知别名
        /*
        NSSet *tags = [NSSet setWithArray:@[]];
        [CoreJPush setTags:tags alias:@"" resBlock:^(BOOL res, NSSet *tags, NSString *alias) {
            if(res){
                GGLog(@"注销别名成功：%@,%@",tags,alias);
            }else{
                GGLog(@"注销别名失败");
            }
        }];
         */
        [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            GGLog(@"清除tags成功:%@",iTags);
        } seq:0];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            GGLog(@"清除alias成功:%@",iAlias);
        } seq:0];
        
        //    [NSArray bg_clearArrayWithName:@"columnArr"];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLoginOutNotify object:nil];
        GGLog(@"本地用户信息已清除");
    }
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
    [[NSNotificationCenter defaultCenter] postNotificationName:UserIntegralOrAvatarChanged object:nil];
}

//根据userId来判断跳转到哪个界面
+(void)toUserInforVcOrMine:(NSInteger)userId
{
    UserModel *user = [self getLocalUserModel];
    UIViewController *currentVC = [HttpRequest currentViewController];
    if (user.userId == userId) {
        //如果是用户本人发的文章，直接跳到我的界面
//        [currentVC.navigationController popViewControllerAnimated:NO];
//        UITabBarController *tabbarVC = (UITabBarController *)[HttpRequest getCurrentVC];
//        [tabbarVC setSelectedIndex:4];
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
    if (user&&userId!=0) {
        if (user.userId == userId) {
            return NO;
        }
    }
    return YES;
}





@end
