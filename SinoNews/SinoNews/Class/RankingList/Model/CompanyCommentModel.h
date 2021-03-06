//
//  CompanyCommentModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/19.
//  Copyright © 2018年 Sino. All rights reserved.
//
//企业评论模型

#import <Foundation/Foundation.h>

@interface CompanyCommentModel : NSObject
@property (nonatomic,strong) NSString *userId;      //用户id
@property (nonatomic,strong) NSString *newsId;      //所属新闻的id
@property (nonatomic,strong) NSString *username;    //用户昵称
@property (nonatomic,assign) NSUInteger level;      //用户等级
@property (nonatomic,strong) NSString *avatar;      //用户头像
@property (nonatomic,strong) NSString *comment;     //评论内容
@property (nonatomic,strong) NSString *commentId;   //评论id
@property (nonatomic,strong) NSString *companyId;   //所属游戏公司的id
@property (nonatomic,strong) NSString *createTime;  //评论时间
@property (nonatomic,assign) NSInteger likeNum;     //点赞数
@property (nonatomic,assign) BOOL isPraise;         //是否被点赞了

@property (nonatomic,strong) NSString *parentId;    //父id
@property (nonatomic,strong) NSString *replyNum;    //回复数
@property (nonatomic,strong) NSArray <CompanyCommentModel *> *replyList;    //回复数组

@property (nonatomic,strong) NSString *ip;          //评论发布地址
@property (nonatomic,strong) NSString *title;       //所属新闻的标题

//用户信息页专用，展示新闻图片数组
@property (nonatomic, strong) NSArray *newsImages;
@property (nonatomic, assign) NSInteger newsType;    //新闻类型：0普通 1收费

@end
