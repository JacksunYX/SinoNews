//
//  MineNet.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//我的接口

#ifndef MineNet_h
#define MineNet_h

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

#endif /* MineNet_h */
