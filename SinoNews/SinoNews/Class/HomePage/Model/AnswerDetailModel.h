//
//  AnswerDetailModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerDetailModel : NSObject

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *newsTitle;   //新闻标题
@property (nonatomic,strong) NSArray  *comments;    //评论数组
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *contentUrl;  //内容的url
@property (nonatomic,strong) NSString *createTime;

@property (nonatomic,assign) NSInteger commentCount;//评论数
@property (nonatomic,assign) NSInteger answerCount;
@property (nonatomic,assign) NSInteger favorCount;
@property (nonatomic,assign) NSInteger hasFollow;   //是否关注
@property (nonatomic,assign) NSInteger hasPraise;   //是否点赞
@property (nonatomic,assign) NSInteger newsId;

@property (nonatomic,assign) NSInteger userId;

@end
