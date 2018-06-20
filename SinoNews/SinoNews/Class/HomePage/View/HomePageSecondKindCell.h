//
//  HomePageSecondKindCell.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第一类cell

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
#import "TopicModel.h"

#define HomePageSecondKindCellID @"HomePageSecondKindCellID"


@interface HomePageSecondKindCell : UITableViewCell

@property (nonatomic,strong) TopicModel *model;

@end
