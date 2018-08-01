//
//  ExchangeRecordCell.h
//  SinoNews
//
//  Created by Michael on 2018/8/1.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用来展示积分-管理-兑换记录的cell


#import <UIKit/UIKit.h>
#import "ExchangeRecordModel.h"

#define ExchangeRecordCellID    @"ExchangeRecordCellID"

@interface ExchangeRecordCell : UITableViewCell

@property (nonatomic,strong) ExchangeRecordModel *model;

@end
