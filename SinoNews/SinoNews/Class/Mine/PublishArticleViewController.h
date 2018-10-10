//
//  PublishArticleViewController.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//发布文章编辑页面

#import <UIKit/UIKit.h>
@class NewPublishModel;
@interface PublishArticleViewController : BaseViewController
//0文章免费部分、1问答、2文章付费部分
@property (nonatomic,assign) NSInteger editType;

@property (nonatomic,assign) BOOL isToAudit;        //是否是待审核
@property (nonatomic,copy) NSString *channelId;     //文章发布的频道

@property (nonatomic, strong) NewPublishModel *draftModel;

//新增
@property (nonatomic,assign) BOOL isPayArticle;     //是否是付费文章
@property (nonatomic,copy) NSString *paidContent;    //付费内容
@property (nonatomic,copy) NSString *freeContent;   //免费内容
@property (nonatomic,copy) NSString *articleTitle;  //文章标题

@end
