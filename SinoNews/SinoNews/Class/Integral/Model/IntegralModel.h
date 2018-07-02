//
//  IntegralModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//积分列表模型

#import <Foundation/Foundation.h>

@interface IntegralModel : NSObject
@property(nonatomic,assign) NSInteger balanceType;      //收支类型：1收入，-1支出
@property(nonatomic,strong) NSString *pointsChange;     //改变
@property(nonatomic,strong) NSString *pointsType;       //行为
@property(nonatomic,strong) NSString *time;             //时间
@property(nonatomic,assign) NSInteger remialPoints;     //剩余

@end
