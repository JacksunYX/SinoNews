//
//  UserInfoCommentCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户信息中的评论列表cell

#import <UIKit/UIKit.h>

#define UserInfoCommentCellID  @"UserInfoCommentCellID"

@interface UserInfoCommentCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@end
