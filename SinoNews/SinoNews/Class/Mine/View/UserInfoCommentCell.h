//
//  UserInfoCommentCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户信息中的评论列表cell

#import <UIKit/UIKit.h>
#import "CompanyCommentModel.h"

#define UserInfoCommentCellID  @"UserInfoCommentCellID"

@interface UserInfoCommentCell : UITableViewCell

@property (nonatomic,strong) CompanyCommentModel *model;

@property (nonatomic,copy) void(^clickNewBlock)(void);

@end
