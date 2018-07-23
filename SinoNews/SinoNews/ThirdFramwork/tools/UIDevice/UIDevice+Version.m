//
//  UIView+Version.m
//  SinoNews
//
//  Created by Michael on 2018/7/23.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UIDevice+Version.h"

@implementation UIDevice (Version)

//获取app版本
+(NSString *)appVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(info));
    
    // app名称
//    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // app版本
    NSString *app_version = info[@"CFBundleShortVersionString"];
//    GGLog(@"app版本号：%@",app_version);
    // app build版本
//    NSString *app_build = infoDictionary[@"CFBundleVersion"];
    
    return app_version;
}

@end
