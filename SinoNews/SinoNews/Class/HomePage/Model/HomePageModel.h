//
//  HomePageModel.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageModel : NSObject
@property (nonatomic,assign) NSInteger channelId;   //所属频道的id
@property (nonatomic,strong) NSString *createStamp; //文章创建时间戳
@property (nonatomic,strong) NSString *createTime;  //文章创建时间
@property (nonatomic,assign) NSInteger news_id;        //文章id
@property (nonatomic,strong) NSString *labelName;   //
@property (nonatomic,strong) NSString *newsTitle;
@property (nonatomic,strong) NSString *newsType;
@property (nonatomic,assign) NSInteger topicId;
@property (nonatomic,strong) NSString *topicName;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,assign) NSInteger viewCount;   //阅读量
@property (nonatomic,assign) NSInteger commentCount;//评论量
@end
