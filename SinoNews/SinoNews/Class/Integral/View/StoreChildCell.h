//
//  StoreChildCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义展示商城相关的cell

#import <UIKit/UIKit.h>
#import "ProductModel.h"

#define StoreChildCellID @"StoreChildCellID"

@interface StoreChildCell : UITableViewCell

@property(nonatomic,strong) ProductModel *model;

@end
