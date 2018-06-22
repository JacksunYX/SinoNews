//
//  HomePageFirstKindCell.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第一类cell(右边一图、专题)

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

#define HomePageFirstKindCellID @"HomePageFirstKindCellID"
#define HomePageFirstKindCellH (kScaelW(130)*80/130 + 20)

@interface HomePageFirstKindCell : UITableViewCell
@property (nonatomic,strong) HomePageModel *model;

@end
