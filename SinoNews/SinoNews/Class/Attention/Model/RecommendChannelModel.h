//
//  RecommendChannelModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//推荐关注-频道模型

#import <Foundation/Foundation.h>

@interface RecommendChannelModel : NSObject

@property (nonatomic,assign) NSUInteger channelId;
@property (nonatomic,assign) NSUInteger defaultChannel; //是否是默认频道
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSUInteger priority;       //频道优先级
@property (nonatomic,assign) NSUInteger status;         //频道状态
//只是用来标注该频道是否被关注,后台是不带这个参数的，所以默认都还没有关注
@property (nonatomic,assign) BOOL isAttention;

@end
