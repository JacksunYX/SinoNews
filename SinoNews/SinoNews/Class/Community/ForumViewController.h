//
//  ForumViewController.h
//  SinoNews
//
//  Created by Michael on 2018/10/23.
//  Copyright © 2018 Sino. All rights reserved.
//
//版块主界面
//选择发布到的版块界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForumViewController : TopBaseViewController
@property(nonatomic,strong) SeniorPostDataModel *postModel;

//刷新回调(发表文章成功)
@property (nonatomic,copy) void(^refreshCallBack)(void);
@end

NS_ASSUME_NONNULL_END
