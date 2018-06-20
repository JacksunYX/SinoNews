//
//  NormalNewsModel.m
//  SinoNews
//
//  Created by Michael on 2018/6/20.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NormalNewsModel.h"

@implementation NormalNewsModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"relatedNews" : [HomePageModel class],
             };
}

@end
