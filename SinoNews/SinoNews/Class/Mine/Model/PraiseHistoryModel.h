//
//  PraiseHistoryModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/6.
//  Copyright © 2018年 Sino. All rights reserved.
//
//点赞历史的模型

#import <Foundation/Foundation.h>

@interface PraiseHistoryModel : NSObject

@property(nonatomic,strong) NSString *content;          //点赞的内容
@property(nonatomic,strong) NSString *cutOffTime;       //点赞距离当前的时间
@property(nonatomic,strong) NSArray <UserModel *>*praiseUserInfo;    //点赞用户的数组
@property(nonatomic,strong) NSString *tipMessage;       //提示信息

@end
