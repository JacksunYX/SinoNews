//
//  ThePostCommentTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子的评论

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString * const ThePostCommentTableViewCellID;
@interface ThePostCommentTableViewCell : UITableViewCell
@property (nonatomic,strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
