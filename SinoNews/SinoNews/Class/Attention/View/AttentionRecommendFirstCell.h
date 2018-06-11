//
//  AttentionRecommendFirstCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//
//第一种cell

#import <UIKit/UIKit.h>
#import "AttentionRecommendModel.h"

#define AttentionRecommendFirstCellID @"AttentionRecommendFirstCell"

typedef void(^clickBlock)(NSInteger);

@interface AttentionRecommendFirstCell : UITableViewCell

@property(nonatomic,strong) NSArray *dataSource;

@property (nonatomic, copy) clickBlock selectedIndex;

@end
