
//
//  HomePageBannerModel.h
//  SinoNews
//
//  Created by Michael on 2018/8/14.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页轮播图模型

#import <Foundation/Foundation.h>

@interface HomePageBannerModel : NSObject
@property (nonatomic,strong) NSString *image;       //图片
@property (nonatomic,assign) NSInteger newsId;      //新闻相关id
@property (nonatomic,strong) NSString *newsTitle;   //标题
@property (nonatomic,assign) NSInteger topic;       //是否时专题
@end
