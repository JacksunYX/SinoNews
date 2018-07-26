//
//  DefinedHeader.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//通用宏

#ifndef DefinedHeader_h
#define DefinedHeader_h

//接口域名
#define DefaultDomainName DebugDomain1
//测试环境
#define DebugDomain @"http://api.52softs.cn"
#define DebugDomain1 @"http://192.168.2.142:8087"
#define DebugDomain2 @"http://192.168.2.141:8083"

//正式环境
#define FormalDomain @"https://www.kuaiyishare.com/"

//图片域名
#define defaultUrl DebugImgDomain
//测试环境
#define DebugImgDomain @"http://192.168.2.144:8083"
//正式环境
#define FormalImgDomain @"https://static.kuaiyishare.com"

//商品分享域名
#define GoodShareUrl DebugGoodShareDomain
//测试环境
#define DebugGoodShareDomain @"http://testweb.kuaiyishare.com/Mobile/Toshare/toshare"
//正式环境
#define FormalGoodShareDomain @""

//店铺分享域名
#define ShopShareUrl DebugShopShareDomain
//测试环境
#define DebugShopShareDomain @"http://testweb.kuaiyishare.com/Mobile/Toshare/shopgoodslist"
//正式环境
#define FormalShopShareDomain @""

//域名+版本号+接口名
#define ApiAppending(api) [NSString stringWithFormat:@"%@%@%@",DefaultDomainName,VersionNum,GetSaveString(api)]

//拼接分享商品或商家的链接地址
#define JoinShareWebUrlStr(webUrl,goods_id,business_id,mobile) [webUrl stringByAppendingString:[NSString stringWithFormat:@"?goods_id=%@&business_id=%@&mobile=%@",goods_id,business_id,mobile]]


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR HexColor(#f7f7f7)

//16进制颜色
#define HexColor(hexstring) [UIColor colorWithHexString:@#hexstring]
//16进制颜色带透明度
#define HexColorAlpha(hexStr,a) [UIColor colorWithHexString:@#hexStr alpha:a]

//随机色
#define Arc4randomColor RGB(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define kWhite(x) [UIColor colorWithWhite:x alpha:1.0f]


//从plist文件中查找相对应的字段请求地址
#define NetRequestUrl(key) [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetRequestUrl" ofType:@"plist"]] objectForKey:@#key]

//拼接图片的宏
#define JointImgUrl(imgUrlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DefaultDomainName,imgUrlStr]]

//导航栏颜色
#define NAVIGATIONBAR_COLOR  [UIColor colorWithRed:225.0f/255.0f green:39.0f/255.0f blue:39.0f/255.0f alpha:1.0f]


//设置字体
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFangSC-Light"
//设置不同大小字体
#define PFR26Font [UIFont fontWithName:PFR size:26]
#define PFR20Font [UIFont fontWithName:PFR size:20]
#define PFR18Font [UIFont fontWithName:PFR size:18]
#define PFR16Font [UIFont fontWithName:PFR size:16]
#define PFR15Font [UIFont fontWithName:PFR size:15]
#define PFR14Font [UIFont fontWithName:PFR size:14]
#define PFR13Font [UIFont fontWithName:PFR size:13]
#define PFR12Font [UIFont fontWithName:PFR size:12]
#define PFR11Font [UIFont fontWithName:PFR size:11]
#define PFR10Font [UIFont fontWithName:PFR size:10]
#define PFR9Font [UIFont fontWithName:PFR size:9]

#define AlipayPublicKey  @""


//进行rsa公钥加密
#define ENCRYPTSTR(str) [NSString_Validation encryptString:str publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaPXzkgIgZ2pi9yZmrde80IyBK/OFLvQgAQtVAuxwiVEKw7McTU+drygX+p/yHmZehg31xMzUs5kRJ2qBD9KesTzF0BEEEUn/E8/+FwtIBZ6KdDnIBFTBrdY0Re8AT+zH1mHQ0+MpSp/a2mVgdlPkzQrIQDDO7lf3WAsMVDnEP/wIDAQAB"]




//-------------------弱引用/强引用-------------------------

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;
#define WeakSelf __weak typeof(self) weakSelf = self;

//-------------------弱引用/强引用-------------------------

//GCD封装宏
//主线程异步
#define GCDAsynMain(block) dispatch_async(dispatch_get_main_queue(), block)
//子线程异步
#define GCDAsynGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//几秒后执行
#define GCDAfterTime(time,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);




//-------------------获取设备大小-------------------------
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 64
/** 底部tab高度 */
#define NAVIGATION_TAB_HEIGHT 49

//获取屏幕 宽度、高度

#define ScreenW ([UIScreen mainScreen].bounds.size.width)
#define ScreenH ([UIScreen mainScreen].bounds.size.height)

//根据屏幕宽度比例计算当前宽度，或根据宽高比计算实际高度
#define kScaelW(x) (ScreenW * x/375)
//宽度比例
#define ScaleW (ScreenW/375.0)
//根据屏幕宽度调整字体比例
#define FontScale(f) PFFontR(ScaleW * f)

//-------------------获取设备大小-------------------------




//----------------------系统----------------------------


//获取系统版本
#define IOS_VERSION [[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]


//获取当前语言
#define CurrentLanguage ([NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否iphone 5、是否是iPad
#define is_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen] currentMode].size) : NO)
#define is_Pad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断设备的操做系统是不是ios7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]

//判断当前设备是不是iphone5
#define kScreenIphone5 (([UIScreen mainScreen] bounds].size.height)>=568)


//定义一个define函数
#define TT_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------


//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

#pragma mark - common functions
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

//释放一个对象
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }

#define SAFE_RELEASE(x) [x release];x=nil



//----------------------内存----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[NSBundle mainBundle]pathForResource:file ofType:ext］

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define UIImageNamed(imageName) [UIImage imageNamed:imageName]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------





//----------------------其他----------------------------

//方正黑体简体字体定义
#define FZFont(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
//苹方Light
#define PFFontL(F) [UIFont fontWithName:@"PingFangSC-Light" size:F]
//苹方Regular
#define PFFontR(F) [UIFont fontWithName:@"PingFangSC-Regular" size:F]
//苹方Medium
#define PFFontM(F) [UIFont fontWithName:@"PingFangSC-Medium" size:F]

#define Font(F) [UIFont systemFontOfSize:F]

#define BoldFont(F) [UIFont boldSystemFontOfSize:F]



//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG) [_OBJECT viewWithTag : _TAG]
//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)



//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//偏好设置
#define UserSet(Object,key) \
[USER_DEFAULT setObject:Object forKey:key];\
[USER_DEFAULT synchronize];

#define UserSetBool(bool,key) \
[USER_DEFAULT setBool:bool forKey:key];\
[USER_DEFAULT synchronize];

//偏好获取
#define UserGet(key) [USER_DEFAULT objectForKey:key]

#define UserGetBool(key) [USER_DEFAULT boolForKey:key]

#define UserInfoData [DCUserInfo findAll].lastObject




//由角度获取弧度 由弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)



//单例化一个类
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

//----------------------其他----------------------------





//----------------------提示框----------------------------

//设置加载提示框（第三方框架：MBProgressHUD）
// 加载
#define kShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

//#define kWindow [UIApplication sharedApplication].keyWindow
#define kWindow \
({\
UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;\
while (1)\
{\
if ([vc isKindOfClass:[UITabBarController class]]) {\
vc = ((UITabBarController*)vc).selectedViewController;\
}\
if ([vc isKindOfClass:[UINavigationController class]]) {\
vc = ((UINavigationController*)vc).visibleViewController;\
}\
if (vc.presentedViewController) {\
vc = vc.presentedViewController;\
}else{\
break;\
}\
}\
(vc.view);\
})


#define kBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[kWindow addSubview:aView]; \
} \
} \

#define kShowHUDAndActivity kBackView;[MBProgressHUD showHUDAddedTo:kWindow animated:YES];kShowNetworkActivityIndicator()

#define kHiddenHUD [MBProgressHUD hideAllHUDsForView:kWindow animated:YES]

#define kRemoveBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[UIView animateWithDuration:0.4 animations:^{ \
item.alpha = 0.0; \
} completion:^(BOOL finished) { \
[item removeFromSuperview]; \
}]; \
} \
} \

#define kHiddenHUDAndAvtivity kRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()

//只显示hud
#define ShowHudOnly [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
#define HiddenHudOnly [MBProgressHUD hideHUDForView:kWindow animated:YES];




//设置加载提示框（第三方框架：Toast）
#define LRToast(str)              CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
[kWindow  makeToast:str duration:0.8 position:CSToastPositionCenter style:style];\
kWindow.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
kWindow.userInteractionEnabled = YES;\
});\



// View 圆角和加边框
#define LRViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]







//----------------------字符串是否为空----------------------------

#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO || [str isEqualToString:@"(null)"] ? YES : NO || [str isEqualToString:@"null"] ? YES : NO || [str isEqualToString:@"<null>"] ? YES : NO)

//----------------------字符串是否为空----------------------------


//----------------------返回安全的字符串----------------------------
#define GetSaveString(str) kStringIsEmpty(str)?@"":str

//----------------------返回安全的字符串空----------------------------



//----------------------数组是否为空----------------------------

#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//----------------------数组是否为空----------------------------



//----------------------字典是否为空----------------------------

#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)

//----------------------字典是否为空----------------------------




//----------------------是否是空对象----------------------------

#define kObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//----------------------是否是空对象----------------------------


//字符串宏
//拼接字符串
#define AppendingString(str1,str2) [str1 stringByAppendingString:str2]

//生成url
#define UrlWithStr(str) [NSURL URLWithString:str]

//比较字符串相等
#define CompareString(str1,str2) [str1 isEqualToString:str2]











#endif /* DefinedHeader_h */
