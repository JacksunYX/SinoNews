//
//  NewNewsCommentCell.h
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/7/22.
//  Copyright © 2019 Sino. All rights reserved.
//
//新的评论cell，只作为新闻相关的评论展示

#import <UIKit/UIKit.h>
#import "CompanyCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nullable const NewNewsCommentCellID;

@interface NewNewsCommentCell : UITableViewCell
@property (nonatomic,strong) CompanyCommentModel *model;

//点击头像
@property (nonatomic,copy) void(^avatarBlock)(NSInteger row);
//点赞
@property (nonatomic,copy) void(^praiseBlock)(NSInteger row);
@end

NS_ASSUME_NONNULL_END
