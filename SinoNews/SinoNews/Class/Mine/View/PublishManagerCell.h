//
//  PublishManagerCell.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//发布管理cell

#import <UIKit/UIKit.h>

#define PublishManagerCellID @"PublishManagerCellID"

@interface PublishManagerCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary *model;

@property (nonatomic ,copy) void(^avatarClick)(void);

@property (nonatomic ,copy) void(^newsClick)(void);

@property (nonatomic ,copy) void(^shareClick)(void);
@end
