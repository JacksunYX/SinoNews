//
//  HomePageModel.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//文章列表或推荐文章列表的model

#import <Foundation/Foundation.h>

@interface HomePageModel : NSObject
@property (nonatomic,assign) NSInteger channelId;   //所属频道的id
@property (nonatomic,strong) NSString *createStamp; //文章创建时间戳
@property (nonatomic,strong) NSString *createTime;  //文章创建时间
@property (nonatomic,assign) NSInteger news_id;     //文章id
@property (nonatomic,strong) NSString *labelName;   //
@property (nonatomic,strong) NSString *newsTitle;

@property (nonatomic,assign) NSInteger topicId;     //专题id，为0则代表无
@property (nonatomic,strong) NSString *topicName;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,assign) NSInteger viewCount;   //阅读量
@property (nonatomic,assign) NSInteger commentCount;//评论量

//共有属性
@property (nonatomic, assign) NSInteger itemType;   //1为普通新闻
@property (nonatomic, assign) NSInteger itemId;     //条目id
@property (nonatomic, strong) NSString *itemTitle;  
@property (nonatomic, strong) NSArray *images;      //包含的图片数组

//我的收藏使用
@property (nonatomic,strong) NSString *avatar;  //头像
@property (nonatomic,assign) NSInteger favorId; //收藏id
//新闻类型(0.普通新闻  1.付费新闻 2.问答 3.投票)
@property (nonatomic,strong) NSString *newsType;
@end
