//
//  ThePostDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//
//帖子详情页(快速发帖、高级发帖)

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThePostDetailViewController : BaseViewController
@property (nonatomic,strong) SeniorPostDataModel *postModel;

//刷新评论数的回调
@property (nonatomic,copy) void(^commentBlock)(NSInteger commentCount);

@end

NS_ASSUME_NONNULL_END
