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
//标记第几个分区小标题
@property (nonatomic,assign) NSInteger sectionNum;
//小标题
@property (nonatomic,strong) NSString *title;
//子内容
@property (nonatomic,strong) NSString *content;
//图片相关
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *imageDes;
@property (nonatomic,assign) CGFloat imageW;
@property (nonatomic,assign) CGFloat imageH;
//视频相关
@property (nonatomic,strong) NSData *videoData;    //视频资源
@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *videoDes;
//是否显示排序视图
@property (nonatomic,assign) BOOL isSort;

@end

NS_ASSUME_NONNULL_END
