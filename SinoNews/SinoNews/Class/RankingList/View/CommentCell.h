//
//  CommentCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/19.
//  Copyright © 2018年 Sino. All rights reserved.
//
//评论cell

#import <UIKit/UIKit.h>
#import "CompanyCommentModel.h"

#define CommentCellID   @"CommentCellID"

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) CompanyCommentModel *model;
//点击头像
@property (nonatomic,copy) void(^avatarBlock)(NSInteger row);
//点赞
@property (nonatomic,copy) void(^praiseBlock)(NSInteger row);
//回复
@property (nonatomic,copy) void(^replayBlock)(NSInteger row);
//点击了某个cell里的某条回复的评论
@property (nonatomic,copy) void(^clickReplay)(NSInteger row,NSInteger index);
//查看所有评论
@property (nonatomic,copy) void(^checkAllReplay)(NSInteger row);

@end
