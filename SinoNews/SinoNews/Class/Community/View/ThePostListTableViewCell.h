//
//  ThePostListTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//
//搜索-帖子列表自定义cell

#import <UIKit/UIKit.h>

extern NSString * _Nullable const ThePostListTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ThePostListTableViewCell : UITableViewCell
-(void)setData:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
