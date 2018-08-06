//
//  PublishArticleViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//发布文章编辑页面

#import <UIKit/UIKit.h>

@interface PublishArticleViewController : BaseViewController

@property (nonatomic,assign) NSInteger editType;    //默认文章、1问答

@property (nonatomic,copy) NSString *channelId;     //文章发布的频道

@end
