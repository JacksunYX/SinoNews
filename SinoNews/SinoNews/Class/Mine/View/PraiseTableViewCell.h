//
//  PraiseTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PraiseHistoryModel.h"

#define PraiseTableViewCellID @"PraiseTableViewCellID"

@interface PraiseTableViewCell : UITableViewCell

@property (nonatomic,strong) PraiseHistoryModel *model;

@end
