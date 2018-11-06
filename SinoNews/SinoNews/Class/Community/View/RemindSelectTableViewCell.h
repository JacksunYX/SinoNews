//
//  RemindSelectTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/11/6.
//  Copyright © 2018 Sino. All rights reserved.
//
//提醒选择@用户自定义cell

#import <UIKit/UIKit.h>
#import "RemindPeople.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString * _Nullable const RemindSelectTableViewCellID;

@interface RemindSelectTableViewCell : UITableViewCell
@property (nonatomic,strong) RemindPeople *model;
@end

NS_ASSUME_NONNULL_END
