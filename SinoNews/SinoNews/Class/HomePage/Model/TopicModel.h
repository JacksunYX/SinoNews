//
//  TopicModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/20.
//  Copyright © 2018年 Sino. All rights reserved.
//
//专题模型

#import <Foundation/Foundation.h>

@interface TopicModel : NSObject

@property (nonatomic,strong) NSString *bigImage;
@property (nonatomic,strong) NSString *channelId;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *descript;

@property (nonatomic,strong) NSString *smallImage;
@property (nonatomic,strong) NSString *topicId;
@property (nonatomic,strong) NSString *topicName;

//专题专属
@property (nonatomic,strong) NSArray <HomePageModel *>*topicNewsList;//专题相关文章

@property (nonatomic, assign) NSInteger itemType;   //2为专题
@property (nonatomic, assign) NSInteger itemId;     //条目id
@property (nonatomic, strong) NSString *itemTitle;  //条目标题
@property (nonatomic, strong) NSArray *images;      //包含的图片数组

@end
