//
//  SearchHeadReusableView.h
//  SinoNews
//
//  Created by Michael on 2018/5/30.
//  Copyright © 2018年 Sino. All rights reserved.
//
//collectionView的自定义头部试图

#import <UIKit/UIKit.h>

#define SearchHeadReusableViewID    @"SearchHeadReusableViewID"
#define SearchHeadReusableViewHeight    (50+54)

@interface SearchHeadReusableView : UICollectionReusableView

//设置分区标题和图标
-(void)setTitle:(NSString *)title Icon:(NSString *)image;
//选择回调
@property (nonatomic ,copy) void(^selectBlock)(NSInteger index);

@end
