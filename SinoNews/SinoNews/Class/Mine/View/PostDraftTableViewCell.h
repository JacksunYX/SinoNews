//
//  PostDraftTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子草稿列表cell（也做帖子列表）

#import <UIKit/UIKit.h>

extern NSString *const PostDraftTableViewCellID;

NS_ASSUME_NONNULL_BEGIN

@interface PostDraftTableViewCell : UITableViewCell
-(void)setData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
