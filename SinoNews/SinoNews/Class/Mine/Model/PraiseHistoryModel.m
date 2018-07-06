//
//  PraiseHistoryModel.m
//  SinoNews
//
//  Created by Michael on 2018/7/6.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PraiseHistoryModel.h"

@implementation PraiseHistoryModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"praiseUserInfo":[UserModel class]};
}

@end
