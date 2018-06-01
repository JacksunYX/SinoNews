//
//  RankDetailTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义排行榜cell

#import <UIKit/UIKit.h>

#define RankDetailTableViewCellID @"RankDetailTableViewCellID"

@interface RankDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@end
