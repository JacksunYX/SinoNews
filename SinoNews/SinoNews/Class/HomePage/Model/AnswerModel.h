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
@property (nonatomic,strong) NSString *avatar;
@property (nonatomic,assign) NSInteger favorCount;
@property (nonatomic,assign) NSInteger hasFollow;
@property (nonatomic,strong) NSString *username;

@end
