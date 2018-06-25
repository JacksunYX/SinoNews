//
//  AddressTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//
//管理收获地址cell

#import <UIKit/UIKit.h>
#import "AddressModel.h"

#define AddressTableViewCellID  @"AddressTableViewCellID"

@interface AddressTableViewCell : UITableViewCell

@property (nonatomic,strong) AddressModel *model;

@end
