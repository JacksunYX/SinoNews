//
//  AnswerModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/19.
//  Copyright © 2018年 Sino. All rights reserved.
//
//回答列表模型

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject

@property (nonatomic,assign) NSInteger answerId;
@property (nonatomic,assign) NSInteger userId;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,strong) NSString *html;        //回答纯文本
@property (nonatomic,strong) NSArray *images;       //图片集

@property (nonatomic,assign) BOOL hasPraise;        //是否点赞
@property (nonatomic,assign) NSInteger favorCount;  //点赞数
@property (nonatomic,assign) NSInteger hasFollow;

@end
