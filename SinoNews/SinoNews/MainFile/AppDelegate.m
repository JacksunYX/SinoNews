//
//  AppDelegate.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AppDelegate.h"
#import <XHLaunchAd.h>

@interface AppDelegate ()<XHLaunchAdDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [UINavigationConfig shared].sx_disableFixSpace = NO;//默认为NO  可以修改
    [UINavigationConfig shared].sx_defaultFixSpace = 10;//默认为0 可以修改
    //配置全局刷新参数
//    [[KafkaRefreshDefaults standardRefreshDefaults] setHeadDefaultStyle:KafkaRefreshStyleAnimatableArrow];
//    [[KafkaRefreshDefaults standardRefreshDefaults] setFootDefaultStyle:KafkaRefreshStyleAnimatableArrow];
    
    GGLog(@"BrowsNewsSingleton:%@",BrowsNewsSingleton.singleton.idsArr);
    
    //配置主题
    [GetCurrentFont configTheme];
    
    //每次重启拉取用户信息
    [self requestToGetUserInfo];
    //百度移动统计
    [self addBaiduMobStat];
    //全局调试
//    [[GHConsole sharedConsole] startPrintLog];
//    //键盘监听
//    [IQKeyboardManager sharedManager].enable = NO;
    //集成友盟分享
    [self initThirdShare];
    //设置主页
    [self setMainVC];
    
    [self setADLoadView];
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"reason: %@", exception);
    
    // Internal error reporting
    
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
//    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
//    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    statTracker.enableDebugOn = NO;
//    statTracker.enableExceptionLog = YES;
//    // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
//    [statTracker startWithAppId:@"565a224155"];
}

//集成友盟分享
-(void)initThirdShare
{
    //初始化
    [MGSocialShareHelper configWithUMAppKey:@"5b17b13df29d98533d00009e" umSocialAppSecret:@"" openLog:NO usingHttpsWhenShareContent:NO];
    //配置分享平台
    //微信
    [MGSocialShareHelper configSharePlateform:MGShareToWechatSession withAppKey:@"wx715d540022f70374" appSecret:@"4ca2ea9de17e7b69537d06c831dfb664" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToWechatTimeline withAppKey:@"wx715d540022f70374" appSecret:@"4ca2ea9de17e7b69537d06c831dfb664" redirectURL:@"http://mobile.umeng.com/social"];
    //qq
    [MGSocialShareHelper configSharePlateform:MGShareToQQ withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToQzone withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToTim withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    //微博s
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
        //后台目前的逻辑是，如果没有登录，只给默认头像这一个字段,只能靠这个来判断
        if ([data allKeys].count>1) {
            UserModel *model = [UserModel mj_objectWithKeyValues:data];
            //覆盖之前保存的信息
            [UserModel coverUserData:model];
        }else{
            [UserModel clearLocalData];
        }
    } failure:nil];
}

//设置广告加载框架
-(void)setADLoadView
{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的根控制器
    [XHLaunchAd setWaitDataDuration:2];
    
    [RequestGather requestBannerWithADId:3 success:^(id response) {
        NSArray *adArr = response;
        if (!kArrayIsEmpty(adArr)) {
            //配置广告数据
            ADModel *model = adArr[0];
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            //广告frame
            imageAdconfiguration.frame = CGRectMake(0, 0, ScreenW, ScreenH - 104);
            //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
            imageAdconfiguration.imageNameOrURLString = model.url;
            //设置GIF动图是否只循环播放一次(仅对动图设置有效)
            imageAdconfiguration.GIFImageCycleOnce = NO;
            //缓存机制(仅对网络图片有效)
            //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
            imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
            //图片填充模式
            imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
            //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
            imageAdconfiguration.openModel = model;
            //广告显示完成动画
            imageAdconfiguration.showFinishAnimate = ShowFinishAnimateLite;
            //广告显示完成动画时间
            imageAdconfiguration.showFinishAnimateTime = 0.5;
            //跳过按钮类型
            imageAdconfiguration.skipButtonType = SkipTypeText;
            //后台返回时,是否显示广告
            imageAdconfiguration.showEnterForeground = YES;
            
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint
{
    GGLog(@"广告点击事件");
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    
    if(openModel==nil) return;
    
    ADModel *model = (ADModel *)openModel;
    
    //此处跳转页面
    [UniversalMethod jumpWithADModel:model];
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
    //如果是强制需要更新的话，这里每次进入app也是要检测的
    [VersionCheckHelper requestToCheckVersion:nil popUpdateView:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//app退出时调用
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //保存浏览历史
    [BrowsNewsSingleton.singleton saveBrowHistory];
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
