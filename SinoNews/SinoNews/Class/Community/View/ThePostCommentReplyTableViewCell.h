//
//  ThePostCommentReplyTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子评论的回复

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ThePostCommentReplyTableViewCellID;
@interface ThePostCommentReplyTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
