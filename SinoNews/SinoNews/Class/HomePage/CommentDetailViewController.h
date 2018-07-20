//
//  CommentDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//
//评论详情

#import <UIKit/UIKit.h>
@class CompanyCommentModel;

@interface CommentDetailViewController : BaseViewController
//0.新闻 1.公司 2.回答
@property (nonatomic,assign) NSInteger pushType;
@property (nonatomic,assign) NSInteger answerId;
@property (nonatomic,strong) CompanyCommentModel *model;

@end
