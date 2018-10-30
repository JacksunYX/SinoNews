//
//  HttpRequest.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UploadParam;
typedef void (^ObjectBlock)(id sender);
//block属性的定义方法
typedef void(^Blo)(NSString *s1,UIColor *c);
typedef void(^Block)(NSString *str1);
/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

extern const NSString * DomainString;

@interface HttpRequest : NSObject
/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param Whether 是否显示提示框
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *  @param RefreshAction    无网络点击刷新回调
 */
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             isShowToastd:(BOOL)isshowtoastd
                isShowHud:(BOOL)isshowhud
         isShowBlankPages:(BOOL)isshowblankpages                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
            RefreshAction:(void (^)())RefreshAction;





/**
 *  发送网络请求
 *
 *  @param URLString   请求的网址字符串
 *  @param parameters  请求的参数
 *  @param type        请求的类型
 *  @param resultBlock 请求的结果
 */
+ (void)requestWithURLString:(NSString *)URLString
                  parameters:(id)parameters
                        type:(HttpRequestType)type
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;







#pragma mark -- 请求带token参数的POST请求 --
+ (void)postWithTokenURLString:(NSString *)URLString
                    parameters:(id)parameters
                  isShowToastd:(BOOL)isshowtoastd
                     isShowHud:(BOOL)isshowhud
              isShowBlankPages:(BOOL)isshowblankpages                       success:(void (^)(id res))success
                       failure:(void (^)(NSError *))failure
                 RefreshAction:(void (^)())RefreshAction;



//获取token
+(void)gettoken:(void (^)(id))success;






/**
 *  上传图片文件
 *
 *  @param URLString   上传图片的网址字符串
 *  @param parameters  上传图片的参数
 *  @param uploadimage 上传图片
 *  @param success     上传成功的回调
 *  @param failur    上传失败的回调
 */
+ (void)uploadFileImage:(NSString *)URLString
             parameters:(id)parameters
            uploadImage:(UIImage *)uploadimage
                success:(void (^)(id response))success
                failure:(void (^)(NSError *error))failur
          RefreshAction:(void (^)())RefreshAction;



#pragma mark -- 上传多张图片
+ (void)uploadFileImages:(NSString *)URLString
              parameters:(id)parameters
             uploadImage:(NSMutableArray *)uploadimages
                 success:(void (^)())success
                 failure:(void (^)(NSError *error))failure;



+(void)uploadFileVideo:(NSString *)URLString
            parameters:(id)parameters
       uploadVideoData:(NSData *)uploadVideoData
               success:(void (^)())success
               failure:(void (^)(NSError *error))failure;


//获取App的固定请求参数
+ (NSString *)getapi_tokenwithurlstring:(NSString *)urlstring;



//判断是否有网
+(BOOL)connectedToNetwork;

//判断当前网络状态
+(void)networkStatusChangeAFN;

//获取当前页面的控制器
+ (UIViewController *)getCurrentVC;

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController;

//进行相对应的请求参数的拼接加密方法
+(NSString *)ParameterFormattingSplicing:(NSMutableDictionary *)requestparameterdic WithKey:(NSString *)keyStr;

@end
