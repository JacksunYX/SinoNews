//
//  CompanyDetailModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/19.
//  Copyright © 2018年 Sino. All rights reserved.
//
//企业详情页模型

#import <Foundation/Foundation.h>

@interface SyntheticalRankingModel : NSObject
@property (nonatomic,strong) NSString *rankingId;
@property (nonatomic,strong) NSString *rankingName;
@property (nonatomic,strong) NSString *score;
@end

@interface CompanyDetailModel : NSObject
@property (nonatomic,strong) NSString *area;                //地域
@property (nonatomic,strong) NSString *companyId;           //企业id
@property (nonatomic,strong) NSString *companyName;         //企业名称
@property (nonatomic,strong) NSString *foundTime;           //成立时间
@property (nonatomic,strong) NSString *game;                //游戏
@property (nonatomic,strong) NSString *hasConcerned;        //未知
@property (nonatomic,strong) NSString *information;         //简介
@property (nonatomic,strong) NSString *logo;                //公司logo
@property (nonatomic,strong) NSArray *otherwebsite;         //备用地址
@property (nonatomic,strong) NSString *promos;              //优惠
@property (nonatomic,strong) NSArray *rankings;             //评分数组
@property (nonatomic,strong) NSString *siteThumbnail;       //网站缩略图
@property (nonatomic,strong) SyntheticalRankingModel *syntheticalRanking;  //综合排名
@property (nonatomic,strong) NSString *website;             //官网
@end
