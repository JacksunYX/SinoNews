//
//  HomePageThirdKindCell.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第三类cell(广告：一个大图)

#import <UIKit/UIKit.h>
#import "ADModel.h"

#define HomePageThirdKindCellID @"HomePageThirdKindCellID"
#define HomePageThirdKindCellH 201

@interface HomePageThirdKindCell : UITableViewCell

@property (nonatomic,strong) ADModel *model;

@end
