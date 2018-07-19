//
//  Q&APublishViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//
//添加问题或回复答主的界面

#import "BaseViewController.h"

@interface Q_APublishViewController : BaseViewController

@property (nonatomic,assign) NSInteger news_id;
//提交回调
@property (nonatomic,copy) void(^submitBlock)(void);

@end
