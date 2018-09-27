//
//  BankCardTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

NS_ASSUME_NONNULL_BEGIN
#define BankCardTableViewCellID  @"BankCardTableViewCellID"

@interface BankCardTableViewCell : UITableViewCell

@property (nonatomic,strong) BankCardModel *model;

@end

NS_ASSUME_NONNULL_END
