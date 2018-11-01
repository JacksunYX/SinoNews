//
//  HttpRequest.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HttpRequest.h"
#import "AddressViewController.h"
static float afterTime = 0.5;
static NSString * const ErrorString = @"提示:";
const NSString * DomainString = nil;

@implementation HttpRequest
//获取通用的请求manager
+ (nullable AFHTTPSessionManager *)getQuestManager
{
#if DEBUG
    DomainString = DefaultDomainName;
#else

    if (kStringIsEmpty(DomainString)) {
        NSUInteger count = BrowsNewsSingleton.singleton.domainsArr.count;
        if (count>0) {
            if (kStringIsEmpty(DomainString)) {
                //遍历数组，找到第一个能用的即可
                for (NSString *domain in BrowsNewsSingleton.singleton.domainsArr) {
                    NSString *domainString = [NSString decryptWithText:domain];
//                    GGLog(@"解密后的域名domainString:%@",domainString);
                    if ([[UIApplication sharedApplication] canOpenURL:UrlWithStr(domainString)]) {
                        DomainString = domainString;
                        GGLog(@"有效");
                        break;
                    }else{
                        GGLog(@"无效");
                    }
                }
            }
        }
        
    }
    if (kStringIsEmpty(DomainString)) {
        GGLog(@"无可用域名");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            GCDAsynMain(^{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法连接服务器\n请切换wifi网络尝试或直接发送邮件联系客服info@qsl365.com" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertVC addAction:cancel];
                [[HttpRequest currentViewController] presentViewController:alertVC animated:YES completion:nil];
            });
        });
        return nil;
    }
#endif
    
//    GGLog(@"DomainString:%@",DomainString);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //无条件的信任服务器上的证书
    
    AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
    
    // 客户端是否信任非法证书
    
    securityPolicy.allowInvalidCertificates = YES;
    
    // 是否在证书域字段中验证域名
    
    securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //请求队列的最大并发数
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    //设置请求超时时长
    manager.requestSerializer.timeoutInterval = 10;
    
    //设置请求头中请求数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         nil];
    //设置与后台对接的请求头
    NSString *token = GetSaveString(UserGet(@"token"));
    
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] uuid] forHTTPHeaderField:@"Device-No"];
    [manager.requestSerializer setValue:[UIDevice appVersion] forHTTPHeaderField:@"App-Version"];
    [manager.requestSerializer setValue:CurrentSystemVersion forHTTPHeaderField:@"Os-Version"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Device-Platform"];
    GGLog(@"设备型号:%@",[DeviceTool sharedInstance].deviceModel);
    [manager.requestSerializer setValue:[DeviceTool sharedInstance].deviceModel forHTTPHeaderField:@"Device-Brand"];
    [manager.requestSerializer setValue:@"QSL" forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}

+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager GET:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //直接把返回的参数进行解析然后返回
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"resultdic-----%@",resultdic);
        
        if (success&&resultdic) {
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
                
                //未登陆
                if ([resultdic[@"statusCode"] integerValue] == 110001) {
                    //清空登录状态
                    [UserModel clearLocalData];
                }else{
                    LRToast(AppendingString(ErrorString, resultdic[@"alertMsg"]));
                }
                if (failure) {
                    failure(nil);
                }
            }
            
        }else{
            LRToast(@"返回数据为空！");
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
    if (!manager) {
        return;
    }
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"resultdic-----%@",resultdic);
        //隐藏loding
        HiddenHudOnly;
        
        //取出返回数据
        if (success&&resultdic) {
            
            //成功返回服务器数据
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
                if (isshowtoastd == YES&&[resultdic[@"statusCode"] integerValue] != 110001) {
                    LRToast(AppendingString(ErrorString, resultdic[@"alertMsg"]));
                    
                }else{
                    kWindow.userInteractionEnabled = NO;
                }
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //未登陆
                    if ([resultdic[@"statusCode"] integerValue] == 110001) {
                        //清空登录状态,然后跳转到登录界面
                        [UserModel clearLocalData];
                        
                        [YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                            if (login) {
                                if (RefreshAction) {
                                    GGLog(@"登录成功回调");
                                    RefreshAction();
                                }
                            }
                        }];
                    }else if ([resultdic[@"statusCode"] integerValue] == 400401){
                        //积分够了，但是未设置收获地址,跳转到收获地址设置界面
                        AddressViewController *aVC = [AddressViewController new];
                        [[[HttpRequest currentViewController] navigationController] pushViewController:aVC animated:YES];
                        
                    }
                    if (failure) {
                        failure(nil);
                    }
                });
            }
            
        }else{
            LRToast(@"返回数据为空！");
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
    if (!manager) {
        return;
    }
    //之前直接用初始化方法来拼接请求地址 现在直接拼接
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    //判断显示loding
    if (isshowhud == YES) {
        
        ShowHudOnly;
        
    }
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    [manager POST:baseURLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //把网络请求返回数据转换成json数据
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"resultdic-----%@",resultdic);
        
        //隐藏loding
        HiddenHudOnly;
        
        //取出返回数据
        if (success&&resultdic) {
            
            //成功返回服务器数据
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
                if (isshowtoastd == YES&&[resultdic[@"statusCode"] integerValue] != 110001) {
                    LRToast(AppendingString(ErrorString, resultdic[@"alertMsg"]));
                }else{
                    kWindow.userInteractionEnabled = NO;
                }
                
                GCDAfterTime(afterTime, ^{
                    kWindow.userInteractionEnabled = YES;
                    //未登陆
                    if ([resultdic[@"statusCode"] integerValue] == 110001) {
                        //清空登录状态,然后跳转到登录界面
                        [UserModel clearLocalData];
                        [YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                            if (login) {
                                if (RefreshAction) {
                                    GGLog(@"登录成功回调");
                                    RefreshAction();
                                }
                            }
                        }];
                    }else{
                        if (failure) {
                            failure(nil);
                        }
                    }
                });
            }
            
        }else{
            LRToast(@"返回数据为空！");
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

#pragma mark -- 上传单张图片
+ (void)uploadFileImage:(NSString *)URLString
             parameters:(id)parameters
            uploadImage:(UIImage *)uploadimage
                success:(void (^)(id response))success
                failure:(void (^)(NSError *error))failure
          RefreshAction:(void (^)())RefreshAction
{
    
    AFHTTPSessionManager *manager = [self getQuestManager];
    if (!manager) {
        return;
    }
    NSString *baseURLString = [NSString stringWithFormat:@"%@%@",DomainString,AppendingString(VersionNum, URLString)];
    
    GGLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    ShowHudOnly;
    
    //先对质量压缩
    NSData *imgData = [uploadimage compressWithMaxLength:100 * 1024];
//    UIImage *img = [UIImage imageWithData:imgData];
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
//        NSData *imageData = UIImageJPEGRepresentation(img,1);
//        NSData *imageData = UIImagePNGRepresentation(uploadimage);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imgData
                                    name:@"file" //这里name是后台取数据对应的字段，所以不能乱写
                                fileName:fileName
                                mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        GGLog(@"responseObject-------%@",resultdic);
        HiddenHudOnly;
        
        //取出返回数据
        if (success&&resultdic) {
            if ([resultdic[@"success"] integerValue] == 1) {
                success(resultdic);
            }else{
                LRToast(AppendingString(ErrorString, resultdic[@"alertMsg"]));
                GCDAfterTime(afterTime, ^{
                    //未登陆
                    if ([resultdic[@"statusCode"] integerValue] == 110001) {
                        //清空登录状态,然后跳转到登录界面
                        [UserModel clearLocalData];
                        [YXHeader checkNormalBackLoginHandle:^(BOOL login) {
                            if (login) {
                                if (RefreshAction) {
                                    GGLog(@"登录成功回调");
                                    RefreshAction();
                                }
                            }
                        }];
                    }
                });
            }
        }else{
            LRToast(@"返回数据为空！");
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        GGLog(@"error-------%@",error);
        //隐藏loding
        HiddenHudOnly;
        
        LRToast(@"图片上传失败");
        if (failure) {
            failure(error);
        }
        
    }];
    
}




#pragma mark -- 上传多张图片 -- 如果要上传多张图片只需要for循环遍历数组图片上传 上传图片时把图片转换成字符串传递
+ (void)uploadFileImages:(NSString *)URLString
              parameters:(id)parameters
             uploadImage:(NSMutableArray *)uploadimages
                 success:(void (^)())success
                 failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DomainString,URLString];
    
    [parameters setValue:@"1" forKey:@"client_id"];
    
    [parameters setValue:[HttpRequest  getapi_tokenwithurlstring:URLString] forKey:@"api_token"];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        //通过循环取出图片上传
        for (int i = 0; i < uploadimages.count; i ++) {
            
            UIImage *uploadimage = uploadimages[i];
            
            NSData *imageData =UIImageJPEGRepresentation(uploadimage,1);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            
            NSLog(@"fileName---------%@",fileName);
            
            NSString *picname=[NSString stringWithFormat:@"dt_pic%d",i];
            
            
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:picname
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
            
        }
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}





+(void)uploadFileVideo:(NSString *)URLString
            parameters:(id)parameters
       uploadVideoData:(NSData *)uploadVideoData
               success:(void (^)())success
               failure:(void (^)(NSError *error))failure {
    
    //    //在token获取成功之后进行相应的请求
    //    [self gettoken:^(id tokenStr) {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",@"text/plain",
                                                         nil];
    
    
    NSString *baseURLString=[NSString stringWithFormat:@"%@%@",DomainString,URLString];
    
    [parameters setValue:@"1" forKey:@"client_id"];
    
    [parameters setValue:[HttpRequest  getapi_tokenwithurlstring:URLString] forKey:@"api_token"];
    
    NSLog(@"baseURLString----%@----parameters-----%@",baseURLString,parameters);
    
    NSURLSessionDataTask *task = [manager POST:baseURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:uploadVideoData
                                    name:@"video"
                                fileName:fileName
                                mimeType:@"video/mpeg4"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
        //打印下上传进度
        NSLog(@"uploadProgress.fractionCompleted---%f",uploadProgress.fractionCompleted);
        
        if (uploadProgress.fractionCompleted==1.0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 在主线程中更新 UI
                
            });
            
        }
        
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        
        //上传成功
        NSDictionary *resultdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"responseObject-------%@",resultdic);
        
        //显示提示用户信息
        NSString *msg= [NSString stringWithFormat:@"%@",[resultdic objectForKey:@"mess"]];
        
        LRToast(msg);
        
        if (success) {
            success(resultdic);
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        NSLog(@"error-------%@",error);
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    //    }];
    
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

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            if ([vc isKindOfClass:[RTRootNavigationController class]]) {
                vc = [[(RTRootNavigationController *)vc rt_viewControllers] lastObject];
            }
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

+ (void)yx_hasNetwork:(void(^)(bool has))hasNet
{
    //创建网络监听对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [manager startMonitoring];
    //监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                GGLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                GGLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                GGLog(@"运营商网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                GGLog(@"WiFi网络");
                break;
        }
    }];
    //结束监听
//    [manager stopMonitoring];
}


@end
