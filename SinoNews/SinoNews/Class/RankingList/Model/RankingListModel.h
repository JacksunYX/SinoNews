//
//  RankingListModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//
//排行榜详细排行模型

#import <Foundation/Foundation.h>

@interface RankingListModel : NSObject
@property (nonatomic,strong) NSString *companyId;
@property (nonatomic,strong) NSString *companyLogo;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *currentRank;
@property (nonatomic,strong) NSString *rankingName;
@property (nonatomic,strong) NSString *status;
@end