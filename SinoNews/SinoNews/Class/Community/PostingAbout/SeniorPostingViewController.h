//
//  SeniorPostingViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/2.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SeniorPostingViewController : BaseViewController
@property (nonatomic,strong) SeniorPostDataModel *postModel;
//刷新回调
@property (nonatomic,copy) void(^refreshCallBack)(void);
@end

NS_ASSUME_NONNULL_END
