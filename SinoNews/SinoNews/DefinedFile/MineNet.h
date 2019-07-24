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

//我的关注列表不分页(post)
#define ListMyFocus         @"/api/listMyFocus"

//我的粉丝列表(post)
#define Fans_myFollow       @"/api/myFollow"

//用户签到(post)
#define SignIn              @"/api/user/signIn"
//获取每日任务(get)
#define User_getDailyTask   @"/api/user/getDailyTask"


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
//用户收获地址列表
#define Mall_listAddress    @"/api/mall/listAddress"

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

//我的获赞记录(post)
#define GetPraiseHistory    @"/api/getPraiseHistory"
//我的粉丝关注记录(post)
#define GetFansHistory      @"/api/getFansHistory"
//通知列表(私信)(get)
#define ListReceivedMessages    @"/api/message/listReceivedMessages"

//查看当前用户发表的评论列表(get)
#define GetCurrentUserComments  @"/api/user/getCurrentUserComments"
//查看当前用户发表的文章列表(get)(已经不再使用这个接口了)
#define GetCurrentUserNews  @"/api/user/getCurrentUserNews"


//查询用户待审核的文章(get)
#define ListNewsToReviewForUser @"/api/news/listNewsToReviewForUser"
//查询用户已审核的文章(get)
#define ListCheckedNewsForUser  @"/api/news/listCheckedNewsForUser"
//查询用户草稿箱(get)
#define ListNewsDraftForUser    @"/api/news/listNewsDraftForUser"
//查看草稿(get)
#define BrowseNewsDraft         @"/api/news/browseNewsDraft"
//发布草稿(get)
#define PublishNewsDraft        @"/api/news/publishNewsDraft"


//删除一篇文章(post)
#define RemoveArticle       @"/api/news/remove"

//签到规则
#define News_signRule       @"/api/news/signRule"
//关于我们
#define News_aboutUs        @"/api/news/aboutUs"
//隐私协议
#define News_statement      @"/api/news/statement"
//积分规则
#define News_pointsRule     @"/api/news/pointsRule"
//等级规则
#define News_levelRule      @"/api/news/levelRule"
//广告合作
#define News_cooperation      @"/api/news/cooperation"

//查看未读私信数量(get)
#define GetCountOfUnreadMessage @"/api/message/getCountOfUnreadMessage"
//查看我的回复(get)
#define UserListReply       @"/api/user/listReply"

//错误上报(post)
#define ErrorResponse       @"/api/errorResponse"




#endif /* MineNet_h */
