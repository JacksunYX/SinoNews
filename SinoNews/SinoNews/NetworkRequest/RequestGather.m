//
//  RequestGather.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RequestGather.h"


@implementation RequestGather

//请求banner
+(void)requestBannerWithADId:(NSInteger)adId
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *error))failure
{
    [HttpRequest getWithURLString:Adverts parameters:@{@"advertsPositionId":@(adId)} success:^(id responseObject) {
        NSArray *adArr = [NSMutableArray arrayWithArray:[ADModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"advertsList"]]];
        if (success) {
            success(adArr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
