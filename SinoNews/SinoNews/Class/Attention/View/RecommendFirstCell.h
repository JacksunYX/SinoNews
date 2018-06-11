//
//  RecommendFirstCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionRecommendModel.h"

#define RecommendFirstCellID @"RecommendFirstCellID"

@interface RecommendFirstCell : UICollectionViewCell

@property (nonatomic,strong) AttentionRecommendModel *model;

@property (nonatomic, copy) void (^attentionIndex)(NSInteger row);

@end
