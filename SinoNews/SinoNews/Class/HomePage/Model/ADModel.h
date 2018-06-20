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
@property (nonatomic, strong) NSString *redirectUrl;    //跳转地址
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;            //图片地址


@property (nonatomic, strong) NSString *redirectType;//回调方式？
@property (nonatomic, strong) NSString *carousel;

@property (nonatomic, assign) NSInteger itemType;   //3为广告
@property (nonatomic, assign) NSInteger itemId;     //条目id
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSArray *images;      //包含的图片数组

@end
