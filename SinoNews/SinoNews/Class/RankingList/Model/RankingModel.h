//
//  RankingModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//排行榜首页列表模型

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject
@property (nonatomic,strong) NSString *rankingId;
@property (nonatomic,strong) NSString *rankingLogo;
@property (nonatomic,strong) NSString *rankingName; //名称
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,assign) NSInteger score;       //评分
@end
