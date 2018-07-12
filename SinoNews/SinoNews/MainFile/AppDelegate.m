//
//  AppDelegate.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //配置主题
    [GetCurrentFont configTheme];
    
    //每次重启拉取用户信息
    [self requestToGetUserInfo];
    //百度移动统计
    [self addBaiduMobStat];
    //全局调试
//    [[GHConsole sharedConsole] startPrintLog];
    //键盘监听
    [IQKeyboardManager sharedManager].enable = YES;
    //集成友盟分享
    [self initThirdShare];
    //设置主页
    [self setMainVC];
    
//    GGLog(@"UUID-----%@-----",[[UIDevice currentDevice] uuid]);
    
    return YES;
}


//设置主界面内容
-(void)setMainVC
{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    MainTabbarVC *mainVC = [MainTabbarVC new];
    
    self.window.rootViewController = mainVC;
    
    [self.window makeKeyAndVisible];
}

//百度移动统计
-(void)addBaiduMobStat
{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    statTracker.enableDebugOn = YES;
    // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    [statTracker startWithAppId:@"565a224155"];
}

//集成友盟分享
-(void)initThirdShare
{
    //初始化
    [MGSocialShareHelper configWithUMAppKey:@"5b17b13df29d98533d00009e" umSocialAppSecret:@"" openLog:YES usingHttpsWhenShareContent:NO];
    //配置分享平台
//    [MGSocialShareHelper configSharePlateform:MGShareToWechatSession|MGShareToWechatTimeline withAppKey:@"" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
//    [MGSocialShareHelper configSharePlateform:MGShareToWechatTimeline withAppKey:@"" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToQQ withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToQzone withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToSina withAppKey:@"2509849189" appSecret:@"4a729c55f2d965e781cb9fb3ef236105" redirectURL:@"http://mobile.umeng.com/social"];

    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatSession]) {
        GGLog(@"可以分享到微信朋友圈");
    }
    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToWechatTimeline]) {
        GGLog(@"可以分享到微信好友");
    }
    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQQ]) {
        GGLog(@"可以分享到QQ好友");
    }
    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToQzone]) {
        GGLog(@"可以分享到QQ空间");
    }
    if ([MGSocialShareHelper canBeShareToPlatform:MGShareToSina]) {
        GGLog(@"可以分享到新浪微博");
    }
 
}

//获取用户信息
-(void)requestToGetUserInfo
{
    [HttpRequest getWithURLString:GetCurrentUserInformation parameters:@{} success:^(id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        //后台目前的逻辑是，如果没有登陆，只给默认头像这一个字段,只能靠这个来判断
        if ([data allKeys].count>1) {
            UserModel *model = [UserModel mj_objectWithKeyValues:data];
            //覆盖之前保存的信息
            [UserModel coverUserData:model];
        }else{
            [UserModel clearLocalData];
        }
    } failure:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [MGSocialShareHelper mg_handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


@end
