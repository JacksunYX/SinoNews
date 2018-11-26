//
//  PostReplyModel.m
//  SinoNews
//
//  Created by Michael on 2018/11/26.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子评论、回复模型

#import "PostReplyModel.h"

@implementation PostReplyModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"replyList":[PostReplyModel class],
             
             };
}

@end
