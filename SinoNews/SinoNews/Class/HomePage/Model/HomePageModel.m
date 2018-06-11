//
//  HomePageModel.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"news_id" : @"id"};
}
@end
