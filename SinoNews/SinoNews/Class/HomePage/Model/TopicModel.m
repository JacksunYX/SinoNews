//
//  TopicModel.m
//  SinoNews
//
//  Created by Michael on 2018/6/20.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"descript" : @"description"};
}
@end
