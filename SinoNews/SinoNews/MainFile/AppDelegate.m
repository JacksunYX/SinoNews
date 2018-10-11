//
//  AppDelegate.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AppDelegate.h"
#import <XHLaunchAd.h>
#import <STCObfuscator.h>
#import "AppDelegate+Push.h"

@interface AppDelegate ()<XHLaunchAdDelegate>
@property (nonatomic,assign) BOOL isBackground;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UINavigationConfig shared].sx_disableFixSpace = NO;//默认为NO  可以修改
    [UINavigationConfig shared].sx_defaultFixSpace = 5;//默认为0 可以修改
    //配置全局刷新参数
//    [[KafkaRefreshDefaults standardRefreshDefaults] setHeadDefaultStyle:KafkaRefreshStyleAnimatableArrow];
//    [[KafkaRefreshDefaults standardRefreshDefaults] setFootDefaultStyle:KafkaRefreshStyleAnimatableArrow];
    
#if (DEBUG == 1)
//    STCObfuscator *manager = [STCObfuscator obfuscatorManager];
//    manager.unConfuseClassNames = @[@"UserInfoViewController",@"YYFileHash",@"MJRefresh"];
//    manager.unConfuseMethodPrefix = @[@"SD",@"ZSS",@"AAChart",@"AF",@"YY"];
//    manager.unConfuseClassPrefix = @[@"RAC"];
//    [manager confuseWithRootPath:[NSString stringWithFormat:@"%s", STRING(ROOT_PATH)] resultFilePath:[NSString stringWithFormat:@"%@/STCDefination.h", [NSString stringWithFormat:@"%s", STRING(ROOT_PATH)]] linkmapPath:[NSString stringWithFormat:@"%s", STRING(LINKMAP_FILE)]];
#endif
    
    GGLog(@"BrowsNewsSingleton:%@",BrowsNewsSingleton.singleton.idsArr);
    if (UserGet(@"fontSize")) {
        
    }else{
        UserSet(@"1",@"fontSize")
    }
    
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
    //集成极光推送
//    [self initJPushWithOptions:launchOptions];
    [self setJPush:application didFinishLaunchingWithOptions:launchOptions];
    //设置主页
    [self setMainVC];
    
    [self setADLoadView];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    return YES;
}

void uncaughtExceptionHandler(NSException *exception) {
    
    GGLog(@"reason: %@", exception.reason);
//    GGLog(@"callStackSymbols: %@", exception.callStackSymbols);
    
    NSMutableArray *reasonArr = [NSMutableArray arrayWithArray:exception.callStackSymbols];
    [reasonArr insertObject:exception.reason atIndex:0];
//    GGLog(@"%@",reasonArr);
    // Internal error reporting
    //上报至后台接口
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"message"] = reasonArr;
    
    [HttpRequest postWithURLString:ErrorResponse parameters:parameters isShowToastd:NO isShowHud:NO isShowBlankPages:NO success:^(id response) {
        GGLog(@"已上报");
    } failure:nil RefreshAction:nil];
    sleep(2);
    
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
#ifdef JoinThirdShare
    //初始化5b9f59a9b27b0a34710000da
    [MGSocialShareHelper configWithUMAppKey:@"5b9f59a9b27b0a34710000da" umSocialAppSecret:@"" openLog:NO usingHttpsWhenShareContent:NO];
    //配置分享平台
    //微信
    [MGSocialShareHelper configSharePlateform:MGShareToWechatSession withAppKey:@"wx715d540022f70374" appSecret:@"4ca2ea9de17e7b69537d06c831dfb664" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToWechatTimeline withAppKey:@"wx715d540022f70374" appSecret:@"4ca2ea9de17e7b69537d06c831dfb664" redirectURL:@"http://mobile.umeng.com/social"];
    //qq
    [MGSocialShareHelper configSharePlateform:MGShareToQQ withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToQzone withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    [MGSocialShareHelper configSharePlateform:MGShareToTim withAppKey:@"1106998630" appSecret:@"" redirectURL:@"http://mobile.umeng.com/social"];
    //微博
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
#endif
}

//集成极光推送
-(void)initJPushWithOptions:(NSDictionary *)launchOptions
{
    //注册JPush
//    [CoreJPush registerJPush:launchOptions];
//    //添加一个监听者：此监听者是遵循了CoreJPushProtocol协议
//    [CoreJPush addJPushListener:self];
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
    [XHLaunchAd setWaitDataDuration:1.8];
    
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
            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            //后台返回时,是否显示广告
            imageAdconfiguration.showEnterForeground = NO;
            imageAdconfiguration.duration = 4;
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
    //进入后台
    self.isBackground = YES;
    [self JPushDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self JPushWillEnterForeground:application];
    //如果是强制需要更新的话，这里每次进入app也是要检测的
    [VersionCheckHelper requestToCheckVersion:nil popUpdateView:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //进入前台
    self.isBackground = NO;
}

//app退出时调用
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //保存浏览历史
    [BrowsNewsSingleton.singleton saveBrowHistory];
}

#ifdef JoinThirdShare
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [MGSocialShareHelper mg_handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#endif

/*
#pragma mark --- CoreJPushProtocol ---
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    GGLog(@"收到推送数据:%@",userInfo);
    if (self.isBackground) {
        GGLog(@"从后台进入的");
    }else{
        GGLog(@"从前台进入的");
    }
    //没有redirectType字段则不做处理
    if ([[userInfo allKeys] containsObject:@"redirectType"]) {
        NSInteger redirectType = [userInfo[@"redirectType"] integerValue];
        switch (redirectType) {
            case 0: //跳转到个人私信
                if (self.isBackground) {
                    [[HttpRequest currentViewController].navigationController pushViewController:[OfficialNotifyViewController new] animated:YES];
                }else{
                    MainTabbarVC *keyVC = (MainTabbarVC *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    [keyVC.tabBar showBadgeOnItemIndex:4];
                }
                break;
            case 1: //跳转到个人兑换记录
                
                break;
                
            default:
                break;
        }
    }
    
}
*/
 
@end
