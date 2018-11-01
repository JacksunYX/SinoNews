//
//  ForumDetailTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//
//版块详情页顶部的cell

#import <UIKit/UIKit.h>

extern NSString * _Nullable const ForumDetailTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface ForumDetailTableViewCell : UITableViewCell
-(void)setData:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
