//
//  WbeViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//网页界面

#import "BaseViewController.h"

@interface WebViewController : BaseViewController


/**
 展示标题样式
 0.默认是没有标题
 1.积分规则
 2.等级规则
 3.签到规则
 4.隐私协议
 5.关于
 6.广告合作
 */
@property (nonatomic,assign) NSInteger showType;

@property (nonatomic,strong) NSString *baseUrl;

@end
