//
//  PreviewTextTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-预览文本cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString * const PreviewTextTableViewCellID;
@interface PreviewTextTableViewCell : UITableViewCell
@property (nonatomic,strong) SeniorPostingAddElementModel *model;
@end

NS_ASSUME_NONNULL_END
