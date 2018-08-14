//
//  ArticleModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/20.
//  Copyright © 2018年 Sino. All rights reserved.
//
//发布管理模型

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,assign) NSInteger topicId;
@property (nonatomic,assign) NSInteger itemId;

@property (nonatomic,assign) NSInteger userId;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic,strong) NSString *topicName;

@property (nonatomic,assign) NSInteger itemType;
@property (nonatomic,assign) NSInteger newsType;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,assign) NSInteger createStamp;
@property (nonatomic,assign) NSInteger praiseCount;
@property (nonatomic,assign) NSInteger hasFavor;
@property (nonatomic,assign) NSInteger hasFollow;
@property (nonatomic,assign) NSInteger hasPraised;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic,assign) NSInteger viewCount;



@end
