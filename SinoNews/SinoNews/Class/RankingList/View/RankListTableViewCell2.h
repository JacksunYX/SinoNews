//
//  RankListTableViewCell2.h
//  SinoNews
//
//  Created by Michael on 2018/10/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingListModel.h"

NS_ASSUME_NONNULL_BEGIN

#define RankListTableViewCell2ID @"RankListTableViewCell2ID"
@interface RankListTableViewCell2 : UITableViewCell

@property (nonatomic,strong) RankingListModel *model;

@property (nonatomic,copy) void(^toPlayBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
