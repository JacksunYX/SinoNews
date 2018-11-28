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

#pragma mark --版块
//主版块查询(get)
#define ListMainSection @"/api/forum/section/listMainSection"
//子版块查询(get)
#define ListSubSection @"/api/forum/section/listSubSection"
//所有版块查询(get)
#define ListAllSections @"/api/forum/section/listAllSections"

#pragma mark --版块-搜索
//搜索关键字补全(get)
#define Post_autoComplete  @"/api/post/autoComplete"
//关键字搜索版块及帖子数量(get)
#define ListBySectionForSearch @"/api/post/listBySectionForSearch"
//根据关键字、版块、排序搜索帖子列表(get)
#define ListPostForSearch @"/api/post/listPostForSearch"

#pragma mark --版块详情
//版块公告和置顶(get)
#define ListTopPostForSection @"/api/post/listTopPostForSection"
//版块帖子列表(get)
#define ListPostForSection @"/api/post/listPostForSection"
//浏览一篇帖子(get)
#define Post_browsePost @"/api/post/browsePost"
//帖子评论列表(get)
#define ListPostComments @"/api/forum/post/listPostComments"
//评论帖子/回复评论(post)
#define PostComment @"/api/forum/post/comment"
//查看用户评论列表(get)
#define ListPostCommentsForUser @"/api/forum/post/listPostCommentsForUser"


#pragma mark --读帖
//用户关注版块的帖子列表(get)
#define ListUserAttenPost @"/api/post/listUserAttenPost"

#pragma mark --用户
//用户帖子列表(get)
#define ListPostForUser @"/api/post/listPostForUser"
//收藏的帖子列表(get)
#define Post_myFavor @"/api/forum/post/myFavor"
//批量取消收藏帖子(post)
#define Post_batchCancelFavor @"/api/forum/post/batchCancelFavor"
//收藏\取消收藏帖子(post)
#define Post_favor @"/api/forum/post/favor"

//发帖(post)
#define PublishPost @"/api/post/publishPost"
//投票(get)
#define Post_doVote @"/api/post/doVote"

#endif /* CommunityNet_h */
