//
//  HomePageSecondKindCell.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第二类cell

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
#import "TopicModel.h"

#define HomePageSecondKindCellID @"HomePageSecondKindCellID"


@interface HomePageSecondKindCell : UITableViewCell

@property (nonatomic,strong) HomePageModel *model;

@end
