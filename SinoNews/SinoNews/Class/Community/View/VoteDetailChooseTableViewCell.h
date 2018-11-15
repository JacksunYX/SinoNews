//
//  VoteDetailChooseTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//
//投票详情页展示选项的cell

#import <UIKit/UIKit.h>
#import "VoteChooseInputModel.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const VoteDetailChooseTableViewCellID;

@interface VoteDetailChooseTableViewCell : UITableViewCell
@property (nonatomic,strong) VoteChooseInputModel *model;
@end

NS_ASSUME_NONNULL_END
