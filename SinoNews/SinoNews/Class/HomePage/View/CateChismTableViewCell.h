//
//  CateChismTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/7/19.
//  Copyright © 2018年 Sino. All rights reserved.
//
//问答详情列表cell

#import <UIKit/UIKit.h>
#import "AnswerModel.h"

#define CateChismTableViewCellID    @"CateChismTableViewCellID"

@interface CateChismTableViewCell : UITableViewCell

@property (nonatomic,strong) AnswerModel *model;

@property (nonatomic,copy) void(^praiseBlock)(void);

@end
