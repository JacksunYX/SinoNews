//
//  UserAboutNet.h
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户信息相关接口

#ifndef UserAboutNet_h
#define UserAboutNet_h

//注册发送验证码(get)
#define SendValidCode   @"/api/sendValidCode"
//注册(post)
#define DoRegister      @"/api/doRegister"
//登陆(post)
#define Login           @"/api/login"
//重制密码(post)
#define ResetPassword   @"/api/resetPassword"
//重制密码发送验证码(get)
#define SendValidCodeForAuthentication @"/api/sendValidCodeForAuthentication"
//用户头像(get)
#define UserAvatar       @"/api/user/avatar"
//获取当前登录用户信息(get)
#define GetCurrentUserInformation @"/api/user/getCurrentUserInformation"

#endif /* UserAboutNet_h */
