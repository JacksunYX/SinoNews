//
//  AttentionRecommendThirdCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AttentionRecommendThirdCellID @"AttentionRecommendThirdCellID"

@interface AttentionRecommendThirdCell : UITableViewCell

@property(nonatomic,strong) NSArray *dataSource;

@property (nonatomic, copy) void(^selectedIndex)(NSInteger line,NSInteger row);

@property (nonatomic,copy) void (^attentionBlock)(NSInteger line,NSInteger row);


@end
