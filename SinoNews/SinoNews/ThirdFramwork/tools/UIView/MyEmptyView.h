//
//  MyEmptyView.h
//  SinoNews
//
//  Created by Michael on 2018/7/16.
//  Copyright © 2018年 Sino. All rights reserved.
//
//自定义空白视图

#import "LYEmptyView.h"

@interface MyEmptyView : LYEmptyView

//无数据空白
+ (instancetype)noDataEmptyWithImage:(NSString *)imgStr refreshBlock:(void(^)(void))block;

+ (instancetype)noDataEmptyWithImage:(NSString *)imgStr title:(NSString *)title refreshBlock:(void(^)(void))block;

//无网络空白
+ (instancetype)noNetEmpty;

//自定义图片标题的空白页
+ (instancetype)noDataEmptyWithImage:(NSString *)imgStr title:(NSString *)title;

@end
