//
//  NotifyList.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//通知名汇总

#ifndef NotifyList_h
#define NotifyList_h

//用户登录的通知
#define UserLoginSuccess    @"UserLoginSuccess"

//用户退出登录通知
#define UserLoginOutNotify  @"UserLoginOutNotify"

//设置字体的通知
#define ChangeFontNotify    @"ChangeFontNotify"

//首页提示
#define HomePageNotice      @"HomePageNotice"
//我的提示
#define MineNotice          @"MineNotice"
//清除浏览记录
#define ClearBrowsHistory   @"ClearBrowsHistory"

//夜间模式切换通知
#define NightModeChanged    @"NightModeChanged"

//用户积分或头像变动的通知
#define UserIntegralOrAvatarChanged @"UserIntegralOrAvatarChanged"

//下载图片完成的通知
#define kDownloadImageSuccessNotify @"kDownloadImageSuccessNotify"

#pragma mark --- 推送相关通知名
//新的推送信息来了(用于消息界面更新小红点)
#define NewMessagePush          @"NewMessagePush"



#endif /* NotifyList_h */
