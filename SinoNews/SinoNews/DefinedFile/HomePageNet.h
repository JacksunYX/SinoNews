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
//查看评论
#define ShowComment             @"/api/showComment"

#endif /* HomePageNet_h */
