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

#endif /* CommunityNet_h */
