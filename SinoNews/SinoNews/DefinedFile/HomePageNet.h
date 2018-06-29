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

//栏目管理(get)
#define Channel_listChannels    @"/api/channel/listChannels"
//分页展现指定栏目下的文章(get)
#define News_list               @"/api/news/listForChannel"
//广告轮播图(get)
#define Adverts                 @"/api/adverts"

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

//点赞(post)
//点赞类型(1:回复,2:评论,3:新闻,4:问答,5:公司回复,6:公司评论)
#define Praise                  @"/api/praise"
//是否被点赞(post)
#define IsPraise                @"/api/isPraise"

//关注/取消关注(post)
#define AttentionUser           @"/api/attentionUser"

//搜索相关接口
//热搜关键词(get)
#define News_getNewsKeys        @"/api/news/getNewsKeys"
//搜索文章(get)
#define News_listForSearching   @"/api/news/listForSearching"
//搜索自动补全(get)
#define News_autoComplete       @"/api/news/autoComplete"







#endif /* HomePageNet_h */
