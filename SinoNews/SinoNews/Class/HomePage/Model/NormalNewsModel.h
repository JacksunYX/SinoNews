//
//  NormalNewsModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/20.
//  Copyright © 2018年 Sino. All rights reserved.
//
//普通新闻的模型

#import <Foundation/Foundation.h>
#import "HomePageModel.h"

@interface NormalNewsModel : NSObject
@property (nonatomic,assign) NSInteger allowCollect;    //是否允许收藏
@property (nonatomic,assign) NSInteger allowComment;    //是否允许评论
@property (nonatomic,strong) NSString *author;          //作者名称
@property (nonatomic,strong) NSString *avatar;          //作者头像
@property (nonatomic,assign) NSInteger commentCount;    //评论数
@property (nonatomic,strong) NSArray *comments;         //评论列表
@property (nonatomic,strong) NSString *createTime;      //发布时间
@property (nonatomic,strong) NSString *freeContentUrl;  //免费文章链接
@property (nonatomic,assign) NSInteger hasPaid;         //是否已付费
@property (nonatomic,assign) NSInteger isAttention;     //是否关注
@property (nonatomic,assign) NSInteger isCollection;    //是否收藏
@property (nonatomic,assign) NSInteger hasPraised;      //是否被点赞（点赞都无法取消点赞）
@property (nonatomic,assign) NSInteger isToll;          //文章是否收费
@property (nonatomic,assign) NSInteger isTopic;         //是否是专题
@property (nonatomic,assign) NSInteger newsId;
@property (nonatomic,strong) NSString *newsTitle;
@property (nonatomic,assign) NSInteger points;          //解锁收费部分需要的积分
@property (nonatomic,strong) NSArray <HomePageModel *>*relatedNews; //相关推荐的新闻列表
@property (nonatomic,strong) NSString *tollContentUrl;  //收费内容链接
@property (nonatomic,assign) NSInteger topicId;         //专题id
@property (nonatomic,strong) NSString *topicName;       //专题名称
@property (nonatomic,assign) NSInteger userId;          //发布者id

@property (nonatomic,assign) NSInteger viewCount;   //阅读量
//这里暂时用来判断是哪种展示方式：100无图 101一图
@property (nonatomic, assign) NSInteger itemType;   //1为普通新闻
@property (nonatomic, assign) NSInteger itemId;     //条目id
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSArray *images;      //包含的图片数组

@end
