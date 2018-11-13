//
//  LeftPopDirectoryViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//
//侧边弹出目录控制器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeftPopDirectoryViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *dataSource;
//点击回调
@property (nonatomic,strong) void(^clickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
