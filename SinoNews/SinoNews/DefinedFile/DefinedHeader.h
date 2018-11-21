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
#define DefaultDomainName DebugDomain3
//测试环境
#define DebugDomain @"http://api.52softs.cn"
#define DebugDomain1 @"http://192.168.2.142:8087" //Tony
#define DebugDomain2 @"http://192.168.2.144:8083" //Edison
//正式
#define DebugDomain3 @"https://qsl.bravetroops.biz"



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

#define kWhite(x) [UIColor colorWithWhite:0 alpha:x]


//从plist文件中查找相对应的字段请求地址
#define NetRequestUrl(key) [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetRequestUrl" ofType:@"plist"]] objectForKey:@#key]

//拼接图片的宏
#define JointImgUrl(imgUrlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DomainString,imgUrlStr]]


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
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
//判断设备的操做系统是不是ios7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]


//获取当前语言
#define CurrentLanguage ([NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否iphone 5、是否是iPad
#define is_Retina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen] currentMode].size) : NO)
#define is_Pad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


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
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[NSBundle mainBundle]pathForResource:file ofType:ext]

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

//通知中心
#define kNotificationCenter [NSNotificationCenter defaultCenter]


//由角度获取弧度 由弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)



//单例化一个类
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;
// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+ (className *)shared##className \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

//----------------------其他----------------------------


//单例通用宏
#define SingleH(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define SingleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}
#else
#define singleM static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)shareTools\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
\
-(instancetype)retain\
{\
return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
return MAXFLOAT;\
}
#endif



//----------------------提示框----------------------------

//设置加载提示框（第三方框架：MBProgressHUD）
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

//只显示hud
//#define ShowHudOnly [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
//#define HiddenHudOnly [MBProgressHUD hideHUDForView:kWindow animated:YES];
//重新自定义
#define ShowHudOnly [YJProgressHUD showCustomLoadingInKeyWindow];
#define HiddenHudOnly [YJProgressHUD hide];

//设置加载提示框（第三方框架：Toast）
#define LRToast(str)              CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
[kWindow  makeToast:str duration:0.5 position:CSToastPositionCenter style:style];\
kWindow.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
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
