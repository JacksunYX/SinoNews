//
//  SelectPublishChannelViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//
//选择发表到的版块

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectPublishChannelViewController : BaseViewController
@property(nonatomic,strong) SeniorPostDataModel *postModel;
//刷新回调(发表文章成功)
@property (nonatomic,copy) void(^refreshCallBack)(void);

@end

NS_ASSUME_NONNULL_END
