//
//  CatechismViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/18.
//  Copyright © 2018年 Sino. All rights reserved.
//
//问答文章详情页

#import "BaseViewController.h"

@interface CatechismViewController : BaseViewController

@property (nonatomic,assign) NSInteger news_id;

//刷新评论数的回调
@property (nonatomic,copy) void(^commentBlock)(NSInteger commentCount);

@end
