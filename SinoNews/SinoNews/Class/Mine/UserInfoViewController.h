//
//  UserInfoViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户信息详情页

#import <UIKit/UIKit.h>

@interface UserInfoViewController : BaseViewController

@property (nonatomic,assign) NSUInteger userId;

@property (nonatomic,copy) void(^refreshBlock)(void);

@end
