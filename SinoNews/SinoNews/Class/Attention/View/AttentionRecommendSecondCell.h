//
//  AttentionRecommendSecondCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//
//第二种cell

#import <UIKit/UIKit.h>

#define AttentionRecommendSecondCellID @"AttentionRecommendSecondCellID"

@interface AttentionRecommendSecondCell : UITableViewCell

@property(nonatomic,strong) NSArray *dataSource;

@property (nonatomic, copy) void (^selectedIndex)(NSInteger line,NSInteger row) ;

@property (nonatomic,copy) void (^attentionBlock)(NSInteger line,NSInteger row);

@end
