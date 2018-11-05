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

//上传单张图片
+(void)uploadSingleImage:(UIImage *)image
                 Success:(void (^)(id response))success
                 failure:(void (^)(NSError *error))failure
{
    [HttpRequest uploadFileImage:FileUpload parameters:@{} uploadImage:image success:^(id response){
//        LRToast(@"上传图片成功");
        if (success) {
            success(response);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    } RefreshAction:nil];
}

//上传视频
+(void)uploadVideo:(NSData *)videoData
           Success:(void (^)(id response))success
           failure:(void (^)(NSError *error))failure
{
    [HttpRequest uploadFileVideo:FileUpload parameters:@{} uploadVideoData:videoData success:^(id response){
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//分享成功后需要上报到后台
+(void)shareWithNewsId:(NSInteger)newsId
               Success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure
{
    [HttpRequest postWithURLString:ShareNewsCallback parameters:@{@"newsId":@(newsId)} isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        GGLog(@"分享上报成功");
    } failure:^(NSError *error) {
        GGLog(@"请求失败");
    } RefreshAction:nil];
}







@end
