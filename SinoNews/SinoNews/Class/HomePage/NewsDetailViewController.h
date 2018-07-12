//
//  NewsDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/14.
//  Copyright © 2018年 Sino. All rights reserved.
//
//新闻详情

#import <UIKit/UIKit.h>
@class HomePageModel;
@interface NewsDetailViewController : BaseViewController

@property (nonatomic,assign) NSInteger newsId;

@property (nonatomic,assign) HomePageModel *model;

@end
