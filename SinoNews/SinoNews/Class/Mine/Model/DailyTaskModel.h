//
//  DailyTaskModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 Sino. All rights reserved.
//
//每日任务模型

#import <Foundation/Foundation.h>

@interface DailyListModel : NSObject
@property (nonatomic,assign) BOOL hasAccomplished;  //任务是否完成
@property (nonatomic,strong) NSString *taskIcon;    //任务图标
@property (nonatomic,strong) NSString *taskName;    //任务名称
@property (nonatomic,assign) NSInteger taskPoints;  //任务可得积分

@end

@interface DailyTaskModel : NSObject

@property (nonatomic,assign) NSInteger receivedPoints;  //已获取积分
@property (nonatomic,assign) NSInteger remainingPoints; //剩余可获得积分
@property (nonatomic,strong) NSArray<DailyListModel *> *subTaskList;    //任务列表

@end




