//
//  ReciveMessageModel.m
//  SinoNews
//
//  Created by Michael on 2018/7/6.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ReciveMessageModel.h"

@implementation ReciveMessageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"messageId":@"id"};
}
@end
