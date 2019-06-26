//
//  RankingListNet.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//排行榜接口

#ifndef RankingListNet_h
#define RankingListNet_h

//查询榜单(get)
#define Ranking         @"/api/ranking"

//查询公司排名(get)
#define CompanyRanking  @"/api/companyRanking"

//关键字搜索娱乐场(get) 带分页
#define SearchCompany   @"/api/company/searchCompany"

//公司详情(get)
#define CompanyDetail   @"/api/company/showCompanyDetails"

//游戏公司查看评论(get)
#define CompanyShowComment  @"/api/company/companyShowComment"

//游戏公司查看回复(get)
#define CompanyShowReply @"/api/company/companyShowReply"
//游戏公司添加评论或回复(post)
#define CompanyComments  @"/api/company/companyComments"
//关注/取关游戏公司(post)//目前前端作为关注和取关的接口来使用
#define ConcernCompany  @"/api/company/concernCompany"

//排行规则
#define News_rankRule   @"/api/news/rankRule"

//热门新闻
#define HotContent_hotNews    @"/api/hotNews"
//热门帖子
#define HotContent_hotPost    @"/api/hotPost"
//热门点赞
#define HotContent_hotPraise    @"/api/hotPraise"

#endif /* RankingListNet_h */
