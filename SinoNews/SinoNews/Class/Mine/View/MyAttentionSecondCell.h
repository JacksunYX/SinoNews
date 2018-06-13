//
//  MyAttentionSecondCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//专题

#import <UIKit/UIKit.h>

#define MyAttentionSecondCellID @"MyAttentionSecondCellID"

@interface MyAttentionSecondCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@property (nonatomic, copy) void (^attentionIndex)(NSInteger row);

@end
