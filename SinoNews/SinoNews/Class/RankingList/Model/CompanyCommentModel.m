//
//  CompanyCommentModel.m
//  SinoNews
//
//  Created by Michael on 2018/6/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CompanyCommentModel.h"

@implementation CompanyCommentModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"replyList": [CompanyCommentModel class]};
}

@end
