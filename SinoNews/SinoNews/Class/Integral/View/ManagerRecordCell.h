//
//  ManagerRecordCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用来展示积分-管理中的cell数据

#import <UIKit/UIKit.h>
#define ManagerRecordCellID @"ManagerRecordCellID"

@interface ManagerRecordCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@end
