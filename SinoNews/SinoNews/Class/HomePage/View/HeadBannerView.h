//
//  HeadBannerView.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//首页的自定义滚动视图

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LeftRightMarginType,
    NormalType,
} BannerType;

typedef void(^clickHandleBlock)(NSInteger index);

@class HomePageBannerModel;
@interface HeadBannerView : UIView

@property (nonatomic,copy) clickHandleBlock selectBlock;
@property (nonatomic,assign) BannerType type;
@property (nonatomic,assign) BOOL showTitle;        //是否显示标题
@property (nonatomic,assign) BOOL hiddenPageControl;//隐藏页数控制
@property (nonatomic,assign) CGFloat bottomHeight;  //下方分页空白的高度
-(void)setupUIWithImageUrls:(NSArray *)imgs;
-(void)setupUIWithModels:(NSArray <ADModel*> *)models;
-(void)setupUIWithModels2:(NSArray <HomePageBannerModel*> *)models; //替换

@end
