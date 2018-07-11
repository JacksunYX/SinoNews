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

//上传文件(post)
#define FileUpload          @"/api/fileupload"
//上传并更新用户头像(post)
#define User_updateAvata    @"/api/user/updateAvatar"
//修改性别(post)
#define User_editGender     @"/api/user/editGender"
//完善个人资料(post)
#define User_editUserInfo     @"/api/user/editUserInfo"
//绑定手机(post)
#define User_bindMobile     @"/api/user/bindMobile"
//绑定邮箱(post)
#define User_bindEmail      @"/api/user/bindEmail"
//修改用户密码(post)
#define User_editPassword   @"/api/user/editPassword"


//添加文章(发布文章)(post)
#define News_create         @"/api/news/create"





#endif /* UserAboutNet_h */
