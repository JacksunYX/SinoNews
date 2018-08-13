//
//  HomePageSecondKindCell.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第二类cell(三图)

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
#import "TopicModel.h"

#define HomePageSecondKindCellID @"HomePageSecondKindCellID"


@interface HomePageSecondKindCell : UITableViewCell

@property (nonatomic,strong) HomePageModel *model;

//默认是正常拼接、1是只拼接阅读和发布时间
@property (nonatomic,assign) NSInteger bottomShowType;

@end
