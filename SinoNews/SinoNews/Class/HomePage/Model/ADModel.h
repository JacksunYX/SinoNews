//
//  ADModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/8.
//  Copyright © 2018年 Sino. All rights reserved.
//
//广告模型

#import <Foundation/Foundation.h>

@interface ADModel : NSObject
@property (nonatomic, strong) NSString *advertsId;
@property (nonatomic, strong) NSString *advertsPositionId;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *createTimeDesc;
@property (nonatomic, strong) NSString *createrId;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *priority;
@property (nonatomic, strong) NSString *redirectUrl;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;

@end
