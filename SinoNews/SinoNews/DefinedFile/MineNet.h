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
//批量取关文章(post)
#define Unfavors            @"/api/unfavors"

//保存收获地址(post)
#define Mall_saveAddress    @"/api/mall/saveAddress"

//获取某一用户的详情信息(get)
#define GetUserInformation  @"/api/user/getUserInformation"

//查询某一用户发表的评论列表(get)
#define GetUserComments     @"/api/user/getUserComments"

//查询某一用户发表的文章列表(get)
#define GetUserNews         @"/api/user/getUserNews"

//查询某一用户关注列表(get)
#define ShowUser            @"/api/showUser"
//查询某一用户粉丝列表(get)
#define ShowFollowUser      @"/api/showFollowUser"






#endif /* MineNet_h */
