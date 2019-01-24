//
//  HomePageFourthCell.h
//  SinoNews
//
//  Created by Michael on 2018/6/21.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页第三类cell(无图)

#import <UIKit/UIKit.h>
#import "HomePageModel.h"

#define HomePageFourthCellID @"HomePageFourthCellID"

@interface HomePageFourthCell : UITableViewCell

@property (nonatomic,strong) HomePageModel *model;

//默认是正常拼接、1是只拼接阅读和发布时间
@property (nonatomic,assign) NSInteger bottomShowType;
//是否是专题（小说）
@property (nonatomic,assign) NSInteger isTopic;

@end
