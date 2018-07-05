//
//  MyFansTableViewCell.h
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFansModel.h"

#define MyFansTableViewCellID   @"MyFansTableViewCellID"

@interface MyFansTableViewCell : UITableViewCell

@property (nonatomic,strong) MyFansModel *model;

@property (nonatomic,assign) NSInteger type;    //0默认是互关的图标、1右边关注了则是勾

@property (nonatomic,copy) void (^attentionBlock)(void);

@end
