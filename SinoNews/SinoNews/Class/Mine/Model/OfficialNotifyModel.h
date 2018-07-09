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

@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) NSInteger sendType;    //0官方 1本人

@end
