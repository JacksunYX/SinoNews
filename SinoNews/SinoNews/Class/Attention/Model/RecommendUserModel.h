//
//  RecommendUserModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//推荐关注-用户模型

#import <Foundation/Foundation.h>

@interface RecommendUserModel : NSObject
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,assign) NSUInteger userId;
@property (nonatomic,strong) NSString *username;
//只是用来标注该频道是否被关注,后台是不带这个参数的，所以默认都还没有关注
@property (nonatomic,assign) BOOL isAttention;
@end
