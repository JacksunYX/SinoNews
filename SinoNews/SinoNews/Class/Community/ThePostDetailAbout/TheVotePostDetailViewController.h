//
//  TheVotePostDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//
//投票发帖详情页

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TheVotePostDetailViewController : BaseViewController
@property (nonatomic,strong) SeniorPostDataModel *postModel;
//刷新评论数的回调
@property (nonatomic,copy) void(^commentBlock)(NSInteger commentCount);

@end

NS_ASSUME_NONNULL_END
