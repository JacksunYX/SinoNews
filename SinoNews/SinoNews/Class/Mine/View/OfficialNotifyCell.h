//
//  OfficialNotifyCell.h
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfficialNotifyModel.h"

#define OfficialNotifyCellID    @"OfficialNotifyCell"

@interface OfficialNotifyCell : UITableViewCell

@property (nonatomic,strong) OfficialNotifyModel *model;

@end
