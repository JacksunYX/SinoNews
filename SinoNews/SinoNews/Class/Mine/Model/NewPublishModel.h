//
//  NewPublishModel.h
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//
//发布管理子界面的通用模型

#import <Foundation/Foundation.h>

@interface NewPublishModel : NSObject
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *authorName;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *publishTime;
@property (nonatomic,strong) NSString *image;
//草稿专用，内容
@property (nonatomic,strong) NSString *content;

@property (nonatomic,assign) NSInteger authorId;
@property (nonatomic,assign) NSInteger newsId;
//0.普通新闻 1.付费新闻 2.问答 3.投票， 4.悬赏问答
@property (nonatomic,assign) NSInteger newsType;

@property (nonatomic,assign) NSInteger viewCount;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,assign) NSInteger praiseCount;

//草稿专用-已选频道数组
@property (nonatomic,strong) NSArray *channelIds;
@end
