//
//  SeniorPostingAddVideoCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-添加视频cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const SeniorPostingAddVideoCellID;
@interface SeniorPostingAddVideoCell : UITableViewCell
@property (nonatomic,strong) SeniorPostingAddElementModel *model;
//文本改变回调
@property (nonatomic,copy) void(^inputChangeBlock)(NSString *inputContent);
@end

NS_ASSUME_NONNULL_END
