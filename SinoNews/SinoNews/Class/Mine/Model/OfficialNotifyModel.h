//
//  OfficialNotifyModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//
//官方通知聊天模型

#import <Foundation/Foundation.h>

@interface OfficialNotifyModel : NSObject

@property (nonatomic,strong) NSString *avatar;      //头像
@property (nonatomic,strong) NSString *content;     //内容
@property (nonatomic,strong) NSString *time;        //时间
@property (nonatomic,strong) NSString *plainTime;   //新增，用于根据时间点获取私信
@property (nonatomic,assign) NSInteger type;        //0官方 1本人
@property (nonatomic,assign) NSInteger messageId;   //id
@property (nonatomic,strong) NSString * senderName; //发送人名称


@end
