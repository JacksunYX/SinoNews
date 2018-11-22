//
//  XLChannelModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLChannelModel : NSObject

@property (nonatomic,strong) NSString *channelName;

@property (nonatomic,strong) NSString *channelId;

@property (nonatomic,strong) NSString *channelIds;

@property (nonatomic,assign) NSInteger status;   //1.可以修改，2.系统自带，不可修改

@property (nonatomic,assign) BOOL isNew;

@end
