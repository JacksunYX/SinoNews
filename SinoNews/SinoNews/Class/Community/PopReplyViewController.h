//
//  PopReplyViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//
//假弹窗式回复页面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopReplyViewController : BaseViewController
@property (nonatomic ,copy) void(^finishBlock)(NSDictionary *inputData);
@property (nonatomic ,copy) void(^cancelBlock)(NSDictionary *cancelData);

@property (nonatomic,strong) NSMutableDictionary *inputData;

//显示方法
-(void)showFromVC:(UIViewController *)vc;

//显示方法2
-(void)showFromVC2:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
