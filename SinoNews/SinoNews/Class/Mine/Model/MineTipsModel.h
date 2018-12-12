//
//  MineTipsModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/30.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineTipsModel : NSObject

@property (nonatomic,assign) BOOL hasFans;          //是否有新增粉丝
@property (nonatomic,assign) BOOL hasMessageTip;    //是否有消息提示
@property (nonatomic,assign) BOOL hasNotice;        //是否有通知(站内信)
@property (nonatomic,assign) BOOL hasPraise;        //是否有人点赞文章
@property (nonatomic,assign) BOOL hasReply;        //是否有人回复我
@property (nonatomic,strong) NSString *messageTip;      //消息提示
@property (nonatomic,strong) NSString *pointGameTip;    //积分游戏提示
@property (nonatomic,strong) NSString *pointRechargeTip;//积分充值提示
@property (nonatomic,strong) NSString *shareTip;        //分享提示

@end
