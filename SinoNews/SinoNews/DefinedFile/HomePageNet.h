//
//  HomePageNet.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页接口

#ifndef HomePageNet_h
#define HomePageNet_h

//查看当前用户已关注的频道(get)
#define Channel_listChannels    @"/api/channel/listChannels"
//设置用户关注的频道(post)
#define SetConcernedChannels    @"/api/channel/setConcernedChannels"

//分页展现指定栏目下的文章(get)
#define News_list               @"/api/news/listForChannel"
//广告轮播图(get)
#define Adverts                 @"/api/adverts"
//首页轮播图(get)
#define NewsSlide               @"/api/news/newsSlide"

//获取文章详情(get)
#define BrowseNews              @"/api/news/browseNews"
//查看评论(get)
#define ShowComment             @"/api/showComment"
//回复评论(post)
#define Comments                @"/api/comments"
//查看评论的回复(get)
#define ShowReply               @"/api/showReply"

//新闻收藏(post)
#define Favor                   @"/api/favor"
//是否被收藏(post)
#define IsFavor                 @"/api/isFavor"

//分享文章回调(post)
#define ShareNewsCallback       @"/api/news/shareNewsCallback"

//点赞(post)
//点赞类型(1:回复,2:评论,3:新闻,4:问答,5:公司回复,6:公司评论)
#define Praise                  @"/api/praise"
//是否被点赞(post)
#define IsPraise                @"/api/isPraise"

//关注/取消关注(post)
#define AttentionUser           @"/api/attentionUser"

//是否关注用户(post)
#define IsAttention             @"/api/isAttention"

#pragma mark ---- 搜索相关接口
//热搜关键词(get)
#define News_getNewsKeys        @"/api/news/getNewsKeys"
//搜索文章(get)
#define News_listForSearching   @"/api/news/listForSearching"
//搜索自动补全(get)
#define News_autoComplete       @"/api/news/autoComplete"
//搜索作者(post)
#define ListUserForSearch       @"/api/user/listUserForSearch"

//展示专题详情(get)
#define ShowTopicDetails        @"/api/topic/showTopicDetails"
//专题收藏(get)
#define TopicFavor              @"/api/topic/favor"
//我的专题收藏列表(get)
#define TopicListUserTopic      @"/api/topic/listUserTopic"
//批量取消收藏专题(post)
#define TopicUnfavors           @"/api/topic/unfavors"


#pragma mark ---- 问答相关接口
//回答列表(post)
#define News_listAnswer         @"/api/news/listAnswer"
//回答提问(post)
#define News_answer             @"/api/news/answer"
//查看回答(post)
#define News_browseAnswer       @"/api/news/browseAnswer"
//回答的评论列表(post)
#define ShowAnswerComment       @"/api/showAnswerComment"
//查看回答的评论的回复列表(get)
#define ShowAnswerReply         @"/api/showAnswerReply"
//添加回答的评论或回复(post)
#define AnswerComment           @"/api/answerComment"

#pragma mark ---- 投票相关接口
//专用于获取ios端完整文章内容的接口，现在只用来获取投票
#define News_iosContent         @"/api/news/iosContent"


//支付一篇付费文章(post)
#define PayForNews              @"/api/news/payForNews"

//获取当前app最新版本以做更新检测(get)
#define CurrentVersion          @"/api/currentVersion"





#endif /* HomePageNet_h */
