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

//我的被点赞数(post)
#define MyPraiseNum         @"/api/myPraise"

//我的关注列表(post)
#define Attention_myUser    @"/api/myUser"

//我的粉丝列表(post)
#define Fans_myFollow       @"/api/myFollow"


//用户签到(post)
#define SignIn              @"/api/user/signIn"

//我的收藏
//查看当前用户关注的游戏公司(get)
#define ListConcernedCompanyForUser @"/api/company/listConcernedCompanyForUser"
//查看当前用户关注的文章(新闻)(post)
#define MyFavor             @"/api/myFavor"

//批量取关游戏公司(post)
#define CancelCompanysCollects @"/api/company/batchCancelConcernCompany"








#endif /* MineNet_h */
