//
//  PostHistoryModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/27.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子浏览历史模型

#import "SeniorPostDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostHistoryModel : SeniorPostDataModel

//存储浏览历史
+(void)saveHistory:(SeniorPostDataModel *)model;
//直接获取分好组的浏览历史
+(NSArray *)getSortedHistory;
//清除缓存
+(void)clearLocalHistory;

@end

NS_ASSUME_NONNULL_END
