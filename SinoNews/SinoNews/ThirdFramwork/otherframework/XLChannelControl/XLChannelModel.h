//
//  XLChannelModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/7.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLChannelModel : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *news_id;

@property (nonatomic,assign) BOOL isNew;

@end
