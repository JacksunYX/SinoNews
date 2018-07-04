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
    [NSArray bg_clearArrayWithName:@"columnArr"];
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

@end
