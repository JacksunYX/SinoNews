//
//  CommunityNet.h
//  SinoNews
//
//  Created by Michael on 2018/11/19.
//  Copyright © 2018 Sino. All rights reserved.
//
//版块相关接口

#ifndef CommunityNet_h
#define CommunityNet_h

//主版块查询(get)
#define ListMainSection @"/api/forum/section/listMainSection"
//子版块查询(get)
#define ListSubSection @"/api/forum/section/listSubSection"
//所有版块查询(get)
#define ListAllSections @"/api/forum/section/listAllSections"
//搜索关键字补全(get)
#define Post_autoComplete  @"/api/post/autoComplete"
//关键字搜索版块及帖子数量(get)
#define ListBySectionForSearch @"/api/post/listBySectionForSearch"
//根据关键字、版块、排序搜索帖子列表(get)
#define ListPostForSearch @"/api/post/listPostForSearch"


//版块公告和置顶(get)
#define ListTopPostForSection @"/api/post/listTopPostForSection"
//用户关注版块的帖子列表(get)
#define ListUserAttenPost @"/api/post/listUserAttenPost"

#endif /* CommunityNet_h */
