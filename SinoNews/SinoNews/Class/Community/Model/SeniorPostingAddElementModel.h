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
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSData *videoData;    //视频资源
@property (nonatomic,strong) NSString *videoUrl;


@end

NS_ASSUME_NONNULL_END
