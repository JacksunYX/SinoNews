//
//  YXHeader.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define NAVI_HEIGHT (IPHONE_X ? 88 : 64)
#define BOTTOM_MARGIN (IPHONE_X ? 34 : 0)
#define StatusBarHeight (IPHONE_X ? 44 : 20)

#define TAB_HEIGHT (IPHONE_X ? 83 : 49)
#define ScaleWidth(width) width * WIDTH_SCALE
#define WIDTH_SCALE (([UIScreen mainScreen].bounds.size.width)/375.0)



#import <Foundation/Foundation.h>


@interface YXHeader : NSObject

+ (BOOL)checkLogin;
//新增一个跳转登录正常返回的
+(BOOL)checkNormalBackLogin;
//带回调的登录检测
+(BOOL)checkNormalBackLoginHandle:(void(^)(BOOL login))backHandle;
//登陆成功，保存数据
+(void)loginSuccessSaveWithData:(NSDictionary *)response;

@end
