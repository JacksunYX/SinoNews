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
    NSArray* findAlls = [UserModel bg_findAll:nil];
    if (!kArrayIsEmpty(findAlls)) {
        [UserModel bg_clear:nil];
    }
    GGLog(@"本地用户信息已清除");
}

@end
