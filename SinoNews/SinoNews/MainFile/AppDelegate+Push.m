//
//  AppDelegate+Push.m
//  MK100
//
//  Created by 张金山 on 2018/1/2.
//  Copyright © 2018年txooo. All rights reserved.
//

#import "AppDelegate+Push.h"

#define isIOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define isIOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
//需要替换的部分
#if DEBUG

#define JPushKey    @"338d7414c564982fcee2bddb"

#else

#define JPushKey    @"a94281870b3a7e2799cef64c" //正式

#endif

//推送消息类型
typedef NS_ENUM(NSInteger,JPushType) {
    JPushTypeMessage = 0,   //站内信
    JPushTypeProduct = 1,   //兑换详情
    JPushTypePraise = 2,    //点赞
    JPushTypeFans = 3,      //粉丝关注
};

@implementation AppDelegate (Push)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)setJPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (isIOS10) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if (isIOS8) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    BOOL isProduction;
    NSString *channel;
#if DEBUG
    isProduction = NO;
    channel = @"App Hoc";
#else
    isProduction = YES;
    channel = @"App Store";
#endif
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //iOS 10以下 ios 7以上程序杀死的时候点击收到的通知进行的跳转操作
    if (launchOptions && !isIOS10){
        NSDictionary *pushDict = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleNotification:pushDict];
    }
}

#pragma clang diagnostic pop

#pragma mark 极光推送的代理的方法
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

//ios 6收到通知的做法 可以抛弃
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [self handleNotification:userInfo];
}

//ios 7以上 iOS10 以下处理前台和后台通知的做法
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //前台与后台的处理
    if (application.applicationState == UIApplicationStateActive) {
        //        __weak __typeof(&*self)weakSelf = self;
        //暂不处理
        /*
         [TXAlertView showAlertWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] cancelButtonTitle:@"好的" style:TXAlertViewStyleAlert buttonIndexBlock:^(NSInteger buttonIndex) {
         if (buttonIndex == 1) {
         [weakSelf handleNotification:userInfo];
         }
         } otherButtonTitles:@"去看看", nil];
         */
        
    }else{
        //当程序在后台运行的时候处理的通知
        [self handleNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//ios 10程序在前台收到通知处理
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //ios 10前台获取推送消息内容
        //前台收到消息直接对消息处理 不点击
        [self handleNotificationForground:userInfo];
        
    }else {
        // 判断为本地通知
    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//ios 10在这里处理通知点击跳转
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //ios  无论程序在前台或者程序在后台点击的跳转处理
        [JPUSHService handleRemoteNotification:userInfo];
        [self handleNotification:userInfo];
    }else {
        // 判断为本地通知
        
    }
    completionHandler();  // 系统要求执行这个方法
}

#pragma clang diagnostic pop
//点击推送弹窗进行的处理
- (void)handleNotification:(NSDictionary *)userInfo{
    GGLog(@"点击进入推送回调了~~~");
    if ([[userInfo allKeys] containsObject:@"redirectType"]) {
        
        UIViewController *currentVC = [HttpRequest currentViewController];
        
        NSInteger redirectType = [userInfo[@"redirectType"] integerValue];
        //根据消息类型进行相应的跳转处理
        switch (redirectType) {
            case JPushTypeMessage:  //站内信
            {
                if (![currentVC isKindOfClass:[OfficialNotifyViewController class]]) {
                    
                    [currentVC.navigationController pushViewController:[OfficialNotifyViewController new] animated:YES];
                }else{
                    [(OfficialNotifyViewController *)currentVC requestListMessagesWithLoadType:1];
                }
                
            }
                break;
            case JPushTypeProduct:
            {
                
            }
                break;
            case JPushTypePraise:
            {
                if (![currentVC isKindOfClass:[MessagePraiseViewController class]]) {
                    
                    [currentVC.navigationController pushViewController:[MessagePraiseViewController new] animated:YES];
                }else{
                    [[(MessagePraiseViewController *)currentVC tableView].mj_header beginRefreshing];
                }
            }
                break;
            case JPushTypeFans:
            {
                if (![currentVC isKindOfClass:[MessageFansViewController class]]) {
                    
                    [currentVC.navigationController pushViewController:[MessageFansViewController new] animated:YES];
                }else{
                    [[(MessageFansViewController *)currentVC tableView].mj_header beginRefreshing];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
}

//app在前台运行时收到推送
-(void)handleNotificationForground:(NSDictionary *)userInfo
{
    GGLog(@"app在前台收到推送");
    if ([[userInfo allKeys] containsObject:@"redirectType"]) {
        
        UIViewController *currentVC = [HttpRequest currentViewController];
        
        NSInteger redirectType = [userInfo[@"redirectType"] integerValue];
        //根据消息类型进行相应的跳转处理
        switch (redirectType) {
                
            case JPushTypeMessage:  //站内信
            {
                if (![currentVC isKindOfClass:[OfficialNotifyViewController class]]) {
                    
                    if ([currentVC isKindOfClass:[MessageViewController class]]) {
                        //如果在消息界面
                        [(MessageViewController *)currentVC updataTipStatus:2];
                        
                    }else if ([currentVC isKindOfClass:[MineViewController class]]) {
                        //如果在我的界面
                        [(MineViewController *)currentVC requestUser_tips];
                    }
                    
                }else{
                    [(OfficialNotifyViewController *)currentVC requestListMessagesWithLoadType:1];
                }
                MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [keyVC.tabBar showBadgeOnItemIndex:4];
                
            }
                break;
            case JPushTypeProduct:
            {
                
            }
                break;
            case JPushTypePraise:
            {
                if (![currentVC isKindOfClass:[MessagePraiseViewController class]]) {
                    
                    if ([currentVC isKindOfClass:[MessageViewController class]]) {
                        //如果在消息界面
                        [(MessageViewController *)currentVC updataTipStatus:0];
                        
                    }else if ([currentVC isKindOfClass:[MineViewController class]]) {
                        //如果在我的界面
                        [(MineViewController *)currentVC requestUser_tips];
                    }
                    
                }else{
                    [[(MessagePraiseViewController *)currentVC tableView].mj_header beginRefreshing];
                }
                MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [keyVC.tabBar showBadgeOnItemIndex:4];
            }
                break;
            case JPushTypeFans:
            {
                if (![currentVC isKindOfClass:[MessageFansViewController class]]) {
                    
                    if ([currentVC isKindOfClass:[MessageViewController class]]) {
                        //如果在消息界面
                        [(MessageViewController *)currentVC updataTipStatus:1];
                        
                    }else if ([currentVC isKindOfClass:[MineViewController class]]) {
                        //如果在我的界面
                        [(MineViewController *)currentVC requestUser_tips];
                    }
                }else{
                    [[(MessageFansViewController *)currentVC tableView].mj_header beginRefreshing];
                }
                MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
                [keyVC.tabBar showBadgeOnItemIndex:4];
            }
                break;
                
            default:
            {
                
            }
                break;
        }
        
    }
}

- (void)JPushDidEnterBackground:(UIApplication *)application{
    //重新设置徽标
    [JPUSHService resetBadge];
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)JPushWillEnterForeground:(UIApplication *)application{
    [application setApplicationIconBadgeNumber:0];
}


/**
 处理通知推送的数据

 @param userInfo 推送数据
 @param forground 是否是在前台收到的推送
 */
-(void)processNotify:(NSDictionary *)userInfo isPushFromForground:(BOOL)forground
{
    if (forground) {
        //app在前台时收到的推送
        
    }else{
        //无论是前后台，点击推送
        
    }
}

@end


