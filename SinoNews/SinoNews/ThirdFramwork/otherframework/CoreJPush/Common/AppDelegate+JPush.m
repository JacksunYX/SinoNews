//
//  AppDelegate+JPush.m
//  CoreJPush
//
//  Created by 冯成林 on 15/9/17.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "JPUSHService.h"
#import "CoreJPush.h"

@implementation AppDelegate (JPush)


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    CoreJPush *jpush = [CoreJPush sharedCoreJPush];
    [jpush didReceiveRemoteNotification:userInfo];
}


-(void)showLocalAlert:(NSDictionary *)userInfo
{
    UILocalNotification *notice = [JPUSHService setLocalNotification:[self getNowTimeDate] alertBody:userInfo[@"aps"][@"alert"] badge:-1 alertAction:@"查看" identifierKey:userInfo[@"aps"][@"alert"] userInfo:userInfo soundName:nil];
    [JPUSHService showLocalNotificationAtFront:notice identifierKey:nil];
}

-(NSDate *)getNowTimeDate
{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a = [dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    NSInteger time = [timeString integerValue] + 2;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];

    return date;
    
}

@end
