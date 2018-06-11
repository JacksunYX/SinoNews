//
//  HttpRequest.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest
//获取通用的请求manager
+ (AFHTTPSessionManager *)getQuestManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求队列的最大并发数
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    //设置请求超时时长
    manager.requestSerializer.timeoutInterval = 10;
    
    //设置请求头中请求数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    return manager;
}

+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    GGLog(@"baseURLString:%@",baseURLString);
    GGLog(@"parameters:%@",parameters);
    [manager GET:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //直接把返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"%@",resultdic);
        
        if (success&&resultdic) {
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
//                LRToast(resultdic[@"alertMsg"]);
                LRToast(resultdic[@"errorMsg"]);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
             isShowToastd:(BOOL)isshowtoastd
                isShowHud:(BOOL)isshowhud
         isShowBlankPages:(BOOL)isshowblankpages
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
            RefreshAction:(void (^)())RefreshAction{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //取出返回数据
        if (success&&resultdic) {
            
            //隐藏loding
            HiddenHudOnly;
            
            GGLog(@"resultdic-----%@",resultdic);
            
            //成功返回服务器数据
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
                if (isshowtoastd == YES) {
                    LRToast(resultdic[@"errorMsg"]);
                }
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //隐藏loding
        HiddenHudOnly;
        
        if (failure) {
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}




#pragma mark -- 请求带token参数的POST请求 --
+ (void)postWithTokenURLString:(NSString *)URLString
                    parameters:(id)parameters
                  isShowToastd:(BOOL)isshowtoastd
                     isShowHud:(BOOL)isshowhud
              isShowBlankPages:(BOOL)isshowblankpages
                       success:(void (^)(id res))success
                       failure:(void (^)(NSError *))failure
                 RefreshAction:(void (^)())RefreshAction{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DefaultDomainName,URLString];
    NSString *token = GetSaveString([USER_DEFAULT objectForKey:@"token"]);
    NSString *user_id = GetSaveString([USER_DEFAULT objectForKey:@"user_id"]);
    
    [parameters setValue:token forKey:@"token"];
    
    [parameters setValue:user_id forKey:@"user_id"];
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"resultdic-----%@",resultdic);
        
        //取出返回数据
        if (success) {
            
            HiddenHudOnly;
            
            if (isshowtoastd == YES) {
                
                //显示提示用户信息
                NSString *msg = [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"msg"]];
                
                if ([msg isEqualToString:@"成功"]||kStringIsEmpty(msg)) {
                    
                } else {
                    LRToast(msg);
                }
                
            }
            // 判断登录
            if ([resultdic[@"code"] integerValue] == 10) {
                
                LRToast(resultdic[@"msg"]);
                
                [USER_DEFAULT setObject:@"" forKey:@"token"];
                [USER_DEFAULT setObject:@"" forKey:@"user_id"];
                [USER_DEFAULT synchronize];
                //                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                //                delegate.isLogin = NO;
                GCDAfterTime(1, ^{
                    //                    [[self getCurrentVC] presentViewController:[[YYFNavigationController alloc] initWithRootViewController:[[enterNavigationController alloc]init]] animated:YES completion:nil];
                });
                
            } else {
                
                //成功返回服务器数据
                success(resultdic);
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        GGLog(@"error:%@",error);
        //隐藏loding
        
        HiddenHudOnly;
        LRToast(@"网络故障，请重试");
        
        if (failure) {
            
            //失败返回错误原因
            failure(error);
            
        }
        
    }];
    
}

//获取当前页面的控制器 进行相应的跳转以及视图的添加
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}



@end
