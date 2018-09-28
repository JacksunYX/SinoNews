//
//  UserAlipayModel.h
//  SinoNews
//
//  Created by Michael on 2018/9/28.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户支付宝账号模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAlipayModel : NSObject
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *alipayId;
@property (nonatomic,strong) NSString *creatTime;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,assign) NSInteger userId;
@end

NS_ASSUME_NONNULL_END
