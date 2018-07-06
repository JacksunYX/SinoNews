//
//  ReciveMessageModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/6.
//  Copyright © 2018年 Sino. All rights reserved.
//
//接收到的私信模型(现在用于消息-通知)

#import <Foundation/Foundation.h>

@interface ReciveMessageModel : NSObject
@property(nonatomic,strong) NSString *content;      //私信内容
@property(nonatomic,assign) NSInteger hasReaded;    //是否已读
@property(nonatomic,assign) NSInteger messageId;    //私信id
@property(nonatomic,strong) NSString *senderName;   //发信人
@property(nonatomic,strong) NSString *time;         //发信时间
@end
