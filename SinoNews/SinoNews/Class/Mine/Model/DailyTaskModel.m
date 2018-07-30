//
//  DailyTaskModel.m
//  SinoNews
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "DailyTaskModel.h"

@implementation DailyTaskModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"subTaskList":[DailyListModel class]};
}

@end

@implementation DailyListModel

@end
