//
//  MyAttentionFirstCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//关注的人

#import <UIKit/UIKit.h>

#define MyAttentionFirstCellID @"MyAttentionFirstCellID"

@interface MyAttentionFirstCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@property (nonatomic, copy) void (^attentionIndex)(NSInteger row);

@end
