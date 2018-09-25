//
//  ShareAndFunctionView.h
//  SinoNews
//
//  Created by Michael on 2018/6/27.
//  Copyright © 2018年 Sino. All rights reserved.
//
//基于一个三方库的封装，定制的分享和功能性的弹出视图

#import <UIKit/UIKit.h>

#ifndef JoinThirdShare
typedef NS_ENUM(NSUInteger, MGShareToPlateform) {
    
    MGShareToWechatSession         = 0 ,        //分享到微信
    MGShareToWechatTimeline        =1  ,      //分享到微信朋友圈
    MGShareToWechatFavorite        =2  ,        //分享到微信收藏
    
    MGShareToQQ        =3  ,        //分享到QQ
    MGShareToQzone            =4  ,        //分享到QQ空间
    MGShareToTim           =5   ,        //分享到 tim
    
    MGShareToSina            =6  ,        //分享到新浪
    
    MGShareToDingDing       =7,      // 分享到钉钉
    
    MGShareToAlipay         =8,         // 分享到支付宝
    
    MGShareToRenRen         =9, // 分享到人人
    
    MGShareToDouban         =10, // 分享到豆瓣
    
    MGShareToSMS            =11, // 分享到短信
    
    MGShareToEmail           =12, // 分享到Email
    
    MGShareToYoudao         =13, // 分享到有道
    
    MGShareToEvernote           =14, // 分享到印象笔记
    
    MGShareToLaiWangSession         =15, // 分享到点点虫聊天
    MGShareToLaiWangTimeline            =16, // 分享到点点虫动态
    
    MGShareToLinkedin           =17, // 分享到领英
    
    MGShareToYixinSession           =18, // 分享到易信聊天
    MGShareToYixinTimeline          =19, // 分享到易信动态
    MGShareToYixinFavorite          =20 , // 分享到易信收藏
    
    MGShareToTecentWeibo            =21, // 分享到腾讯微博
    
};
#endif


@interface ShareAndFunctionView : UIView

/**
 显示
 */
+(void)showWithCollect:(BOOL)collect returnBlock:(void(^)(NSInteger section,NSInteger row, MGShareToPlateform sharePlateform)) clickBlock;

//只显示分享items
+(void)showWithReturnBlock:(void (^)(NSInteger section, NSInteger row, MGShareToPlateform sharePlateform))clickBlock;

@end
