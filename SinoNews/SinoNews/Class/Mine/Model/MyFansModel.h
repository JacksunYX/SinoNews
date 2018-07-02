//
//  MyFansModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFansModel : NSObject
@property(nonatomic,strong)NSString *avatar;    //被关注用户头像
@property(nonatomic,assign)NSInteger followId;//关注信息ID
@property(nonatomic,assign)NSInteger followUserId;  //被关注用户ID
@property(nonatomic,assign)NSInteger isFollow;  //是否相互已关注(1:已关注,0:未关注)
@property(nonatomic,assign)NSInteger userId;    //用户ID
@property(nonatomic,strong)NSString *username;  //用户名
@end
