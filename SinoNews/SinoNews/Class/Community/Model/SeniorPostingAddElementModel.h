//
//  SeniorPostingAddElementModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-添加元素的模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeniorPostingAddElementModel : NSObject
//默认0小标题，1文本，2图片，3视频
@property (nonatomic,assign) NSInteger addtType;
@property (nonatomic,assign) NSString *title;
@property (nonatomic,assign) NSString *content;
@property (nonatomic,assign) NSString *image;
@property (nonatomic,assign) NSString *videoUrl;

@end

NS_ASSUME_NONNULL_END
