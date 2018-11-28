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
@property (nonatomic,strong) NSString *parentComment;
@property (nonatomic,strong) NSString *parentCommentAuthor;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSMutableArray <NSString *>*postImages;

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger postId;

@property (nonatomic,assign) NSInteger level;
//评论还是回复，默认no评论，yes回复
@property (nonatomic,assign) BOOL postComment;
@property (nonatomic,assign) BOOL praise;

//本地判断适用(如果是作者本人发的评论或回复，需要显示为楼主)
@property (nonatomic,assign) BOOL isAuthor;


@end

NS_ASSUME_NONNULL_END
