//
//  FansTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFansModel.h"

#define FansTableViewCellID @"FansTableViewCellID"

@interface FansTableViewCell : UITableViewCell

@property (nonatomic,strong) MyFansModel *model;

@end
