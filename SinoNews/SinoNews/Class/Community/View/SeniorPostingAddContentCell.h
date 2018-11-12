//
//  SeniorPostingAddContentCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-添加子内容cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const SeniorPostingAddContentCellID;
@interface SeniorPostingAddContentCell : UITableViewCell
@property (nonatomic,strong) SeniorPostingAddElementModel *model;
@end

NS_ASSUME_NONNULL_END
