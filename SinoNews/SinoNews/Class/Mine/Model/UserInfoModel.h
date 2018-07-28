//
//  UserInfoModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//其他用户模型

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property(nonatomic,strong) NSString *username;     //用户昵称
@property(nonatomic,strong) NSString *lastLoginTime;//用户上次登录时间
@property(nonatomic,strong) NSString *loginTime;    //用户本次登录时间
@property(nonatomic,strong) NSString *avatar;       //用户头像
@property(nonatomic,strong) NSString *birthday;     //用户生日

@property(nonatomic,assign) NSInteger userGroupId;  //使用所属用户组的id
@property(nonatomic,assign) NSInteger userId;       //用户的id

@property(nonatomic,assign) NSInteger postCount;    //用户发表文章的数量
@property(nonatomic,assign) NSInteger followCount;  //用户关注数
@property(nonatomic,assign) NSInteger fansCount;    //用户粉丝数
@property(nonatomic,assign) NSInteger praisedCount; //用户获赞数

@property(nonatomic,assign) NSInteger commentCount; //用户评论的数量
@property(nonatomic,assign) NSInteger favorCount;   //用户收藏数

@property(nonatomic,assign) NSInteger gender;       //用户性别
@property(nonatomic,assign) NSInteger integral;     //用户积分

@property(nonatomic,strong) NSArray *identifications;   //认证数组






@end
