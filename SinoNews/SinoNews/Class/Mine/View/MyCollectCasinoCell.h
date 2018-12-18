//
//  MyCollectCasinoCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//收藏娱乐城cell

#import <UIKit/UIKit.h>
#import "CompanyDetailModel.h"

#define MyCollectCasinoCellID @"MyCollectCasinoCellID"

@interface MyCollectCasinoCell : UITableViewCell

@property (nonatomic,strong) CompanyDetailModel *model;
//官网回调
@property (nonatomic,copy) void(^webPushBlock)(void);
//详情回调
@property (nonatomic,copy) void(^detailBlock)(void);

@end
