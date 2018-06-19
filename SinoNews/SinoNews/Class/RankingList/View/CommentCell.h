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

@end
