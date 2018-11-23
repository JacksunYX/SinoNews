//
//  SeniorPostDataModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖模型

#import <Foundation/Foundation.h>

#import "VoteChooseInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeniorPostDataModel : NSObject
//帖子标题
@property (nonatomic,strong) NSString *postTitle;
//帖子内容
@property (nonatomic,strong) NSString *postContent;
//所包含的子元素数组
@property (nonatomic,strong) NSMutableArray <SeniorPostingAddElementModel *>*dataSource;
//@的用户数组
@property (nonatomic,strong) NSMutableArray *people;

//发布者相关
@property (nonatomic,strong) NSString *avatar;//头像
@property (nonatomic,strong) NSString *author;//发布者
@property (nonatomic,strong) NSString *username;//发布者
@property (nonatomic,assign) NSInteger userId;//id
@property (nonatomic,strong) NSString *createTime;//发布时间
@property (nonatomic,assign) BOOL isAttention;//是否关注
@property (nonatomic,assign) BOOL isCollection;//是否收藏
@property (nonatomic,assign) BOOL hasPraised;//是否点赞
@property (nonatomic,assign) NSInteger praiseCount;//点赞数
//评价:(0无，1好文，2好文+精)
@property (nonatomic,assign) NSInteger rate;

//投票帖子专用属性
//是否是投票
@property (nonatomic,assign) BOOL isVotePost;
//是否已投票
@property (nonatomic,assign) BOOL haveVoted;
//是否已截止
@property (nonatomic,assign) BOOL isoVerdue;
//投票后结果是否可见
@property (nonatomic,assign) BOOL visibleAfterVote;
//投票人数
@property (nonatomic,assign) NSInteger voteNum;
//最大可选数
@property (nonatomic,assign) NSInteger choosableNum;
//投票有效期
@property (nonatomic,assign) NSInteger validityDate;
//投票选项数组
@property (nonatomic,strong) NSMutableArray <VoteChooseInputModel *> *voteSelects;

//详情对接属性
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,strong) NSString *createStamp;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,assign) NSInteger postId;
//帖子类型(1普通帖子、2投票帖子、3高级帖子)
@property (nonatomic,assign) NSInteger postType;
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,assign) NSInteger viewCount;

@end

NS_ASSUME_NONNULL_END
