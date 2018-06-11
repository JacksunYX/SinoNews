//
//  RecommendSecondCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionRecommendModel.h"

#define RecommendSecondCellID @"RecommendSecondCellID"


@interface RecommendSecondCell : UICollectionViewCell

@property (nonatomic,strong) AttentionRecommendModel *model;

@property (nonatomic,strong) NSArray *modelArr;

@property (nonatomic, copy) void (^selectedIndex)(NSInteger line,NSInteger row);

@property (nonatomic, copy) void (^attentionIndex)(NSInteger line,NSInteger row);

@end
