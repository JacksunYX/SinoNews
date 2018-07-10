//
//  RequestGather.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//部分通用的请求集合


#import <Foundation/Foundation.h>

@interface RequestGather : NSObject


/**
 请求banner接口

 @param adId 下标,具体查看公司文档
 */
+(void)requestBannerWithADId:(NSInteger)adId
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *error))failure;




@end
