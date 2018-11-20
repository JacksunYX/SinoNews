//
//  UserAttentionOrFansVC.h
//  SinoNews
//
//  Created by Michael on 2018/7/5.
//  Copyright © 2018年 Sino. All rights reserved.
//
//某一用户的关注列表或粉丝列表

#import <Foundation/Foundation.h>

@interface UserAttentionOrFansVC : BaseViewController

@property (nonatomic,assign) NSInteger userId;  //用户id
//0关注、1粉丝、2搜索作者
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) NSString *keyword;

@end
