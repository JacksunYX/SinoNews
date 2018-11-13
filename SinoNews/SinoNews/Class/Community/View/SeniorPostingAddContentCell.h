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
//排序回调
@property (nonatomic,copy) void(^deleteBlock)(void);
@property (nonatomic,copy) void(^goUpBlock)(void);
@property (nonatomic,copy) void(^goDownBlock)(void);
@end

NS_ASSUME_NONNULL_END
