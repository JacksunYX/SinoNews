//
//  RankDetailTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义排行榜cell

#import <UIKit/UIKit.h>
#import "RankingListModel.h"

#define RankListTableViewCellID @"RankListTableViewCellID"

@interface RankListTableViewCell : UITableViewCell

@property (nonatomic,strong) RankingListModel *model;

@property (nonatomic,copy) void(^toPlayBlock)(void);

@end
