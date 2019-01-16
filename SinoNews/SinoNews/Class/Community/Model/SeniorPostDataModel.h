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
@property (nonatomic,strong) NSMutableArray <RemindPeople *>*remindPeople;
//认证数组
@property (nonatomic,strong) NSMutableArray *identifications;
//发布者相关
@property (nonatomic,strong) NSString *avatar;//头像
@property (nonatomic,strong) NSString *author;//发布者
@property (nonatomic,strong) NSString *username;//发布者
@property (nonatomic,assign) NSInteger userId;//id
@property (nonatomic,strong) NSString *createTime;//发布时间
@property (nonatomic,assign) BOOL isAttention;//是否关注
@property (nonatomic,assign) BOOL isCollection;//是否收藏
@property (nonatomic,assign) BOOL hasPraised;//是否点赞
@property (nonatomic,assign) NSInteger level;//等级
@property (nonatomic,assign) NSInteger praiseCount;//点赞数
//评价:(0无，1好文，2好文+精)
@property (nonatomic,assign) NSInteger rate;
//是否已无效
@property (nonatomic,assign) BOOL hasExpired;
//是否是付费
@property (nonatomic,assign) BOOL isToll;
//是否已付费
@property (nonatomic,assign) BOOL hasPaid;
//付费所需积分
@property (nonatomic,assign) NSInteger points;

//投票帖子专用属性
//是否是投票
@property (nonatomic,assign) BOOL isVotePost;
//是否已投票
@property (nonatomic,assign) BOOL haveVoted;
//是否已截止
@property (nonatomic,assign) BOOL isoVerdue;
//是否是作者本人发表的投票(本人不能参与投票)
@property (nonatomic,assign) BOOL postAuthor;
//投票后结果是否可见
@property (nonatomic,assign) NSInteger visibleAfterVote;
//投票总数
@property (nonatomic,assign) NSInteger totalPolls;
//最大可选数
@property (nonatomic,assign) NSInteger choosableNum;
//投票参与人数
@property (nonatomic,assign) NSInteger votePeople;
//投票有效期
@property (nonatomic,assign) NSInteger validityDate;
//过期时间
@property (nonatomic,strong) NSString *expiredTime;
//投票选项数组
@property (nonatomic,strong) NSMutableArray <VoteChooseInputModel *> *voteSelects;

//记录回复时间的时间戳
@property (nonatomic,strong) NSString *lastCommentTime;

//详情对接属性
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,strong) NSString *createStamp;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,assign) NSInteger postId;
//帖子类型(1普通帖子、2投票帖子、3高级帖子)
@property (nonatomic,assign) NSInteger postType;
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) NSString *sectionIcon;
@property (nonatomic,strong) NSString *sectionName;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,assign) NSInteger viewCount;
//标记帖子发布状态(0审核中、1已审核、2审核未通过)
@property (nonatomic,assign) NSInteger status;
//只用于收藏
@property (nonatomic,assign) NSInteger favorId;

//只用于保存为本地草稿时的时间戳
@property (nonatomic,strong) NSString *saveTime;
//方法
//获取本地草稿列表
+(NSMutableArray *)getLocalDrafts;
//新增一个草稿
+(void)addANewDraft:(SeniorPostDataModel *)postModel;
//移除某个草稿
+(void)remove:(SeniorPostDataModel *)postModel;
//清除所有草稿
+(void)removeAllDrafts;

//检查当前模型是否有需要保存的数据
-(BOOL)isContentNeutrality;

@end

NS_ASSUME_NONNULL_END
