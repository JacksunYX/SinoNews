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
@property (nonatomic,strong) NSString *postTitle;
//帖子图片
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSMutableArray <NSString *>*commentImage;
//认证数组
@property (nonatomic,strong) NSMutableArray *identifications;

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger postId;
@property (nonatomic,assign) NSInteger postType;
@property (nonatomic,assign) NSInteger level;
//评论还是回复，默认no评论，yes回复
@property (nonatomic,assign) BOOL postComment;
@property (nonatomic,assign) BOOL praise;
@property (nonatomic,assign) NSInteger likeNum;

//用于判断是否是楼主
@property (nonatomic,assign) BOOL isAuthor;


@end

NS_ASSUME_NONNULL_END
