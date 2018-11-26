//
//  PostReplyModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/26.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子评论、回复模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostReplyModel : NSObject
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *ip;
@property (nonatomic,strong) NSMutableArray <NSString *>*postImages;
@property (nonatomic,strong) NSMutableArray <PostReplyModel *>*replyList;

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger postId;

@property (nonatomic,assign) NSInteger postType;
@property (nonatomic,assign) NSInteger commentTotal;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) NSInteger likeNum;

@property (nonatomic,assign) NSInteger isPraise;
@property (nonatomic,assign) NSInteger replyNum;



@end

NS_ASSUME_NONNULL_END
