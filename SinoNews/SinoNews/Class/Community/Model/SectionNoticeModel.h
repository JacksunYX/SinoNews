//
//  SectionNoticeModel.h
//  SinoNews
//
//  Created by Michael on 2018/11/21.
//  Copyright © 2018 Sino. All rights reserved.
//
//版块公告模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SectionNoticeModel : NSObject
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger creator;
@property (nonatomic,strong) NSString *endTime;
@property (nonatomic,assign) NSInteger editor;
@property (nonatomic,strong) NSString *editTime;
@property (nonatomic,assign) NSInteger noticeId;
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *url;
@end

NS_ASSUME_NONNULL_END
