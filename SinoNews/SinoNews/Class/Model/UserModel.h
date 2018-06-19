//
//  UserModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户模型

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//用户登陆使用账号
@property (nonatomic,strong) NSString *account;
//用户昵称
@property (nonatomic,strong) NSString *username;
//用户头像
@property (nonatomic,strong) NSString *avatar;
//用户上次登录时间
@property (nonatomic,strong) NSString *lastLoginTime;
//用户本次登录时间
@property (nonatomic,strong) NSString *loginTime;
//用户已关注频道
@property (nonatomic,strong) NSArray *concernedChannels;

//用户id
@property (nonatomic,assign) NSUInteger userId;
//用户组id
@property (nonatomic,assign) NSUInteger userGroupId;
//用户评论数量
@property (nonatomic,assign) NSUInteger commentCount;
//用户购买商品列表
@property (nonatomic,assign) NSUInteger products;
//用户发表文章数量
@property (nonatomic,assign) NSUInteger postCount;
//用户粉丝数
@property (nonatomic,assign) NSUInteger fansCount;
//用户收藏数
@property (nonatomic,assign) NSUInteger favorCount;
//用户关注数
@property (nonatomic,assign) NSUInteger followCount;
//用户积分
@property (nonatomic,assign) long integral;









@end
