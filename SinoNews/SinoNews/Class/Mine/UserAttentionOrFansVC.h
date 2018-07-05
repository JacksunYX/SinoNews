//
//  UserAttentionOrFansVC.h
//  SinoNews
//
//  Created by Michael on 2018/7/5.
//  Copyright © 2018年 Sino. All rights reserved.
//
//某一用户的关注列表或粉丝列表

#import <Foundation/Foundation.h>

@interface UserAttentionOrFansVC : UIViewController

@property (nonatomic,assign) NSInteger userId;  //用户id

@property (nonatomic,assign) NSInteger type;    //0关注、1粉丝

@end
