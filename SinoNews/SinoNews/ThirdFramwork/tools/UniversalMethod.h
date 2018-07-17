//
//  UniversalMethod.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADModel,TopicModel;

@interface UniversalMethod : NSObject

/**
 根据广告模型跳转到不同界面

 @param model 模型
 */
+(void)jumpWithADModel:(ADModel *)model;


/**
 拿本地缓存的频道数据与后台数据进行比对

 @param serverData  后台频道数组
 @param reason      回调block
 */
+(void)compareChannels:(NSArray *)serverData
          reasonAction:(void (^)(BOOL changed1 ,BOOL changed2 , NSArray *attentionArr, NSArray *unAttentionArr))reason;

//获取上拉加载更多的时间节点
+(NSString *)getTopLoadTimeWithData:(NSArray *)data;

//获取下拉加载更多的时间节点
+(NSString *)getBottomLoadTimeWithData:(NSArray *)data;


@end
