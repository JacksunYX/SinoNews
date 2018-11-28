//
//  ThePostCommentReplyTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子评论的回复

#import <UIKit/UIKit.h>
#import "PostReplyModel.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ThePostCommentReplyTableViewCellID;
@interface ThePostCommentReplyTableViewCell : UITableViewCell
@property (nonatomic,strong) PostReplyModel *model;

//点击头像
@property (nonatomic,copy) void(^avatarBlock)(NSInteger row);
//点赞
@property (nonatomic,copy) void(^praiseBlock)(NSInteger row);

@end

NS_ASSUME_NONNULL_END
