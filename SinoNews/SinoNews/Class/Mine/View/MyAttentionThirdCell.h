//
//  MyAttentionThirdCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//频道

#import <UIKit/UIKit.h>

#define MyAttentionThirdCellID @"MyAttentionThirdCellID"

@interface MyAttentionThirdCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *model;

@property (nonatomic, copy) void (^attentionIndex)(NSInteger row);

@end
