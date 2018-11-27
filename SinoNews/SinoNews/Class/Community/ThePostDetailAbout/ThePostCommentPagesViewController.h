//
//  ThePostCommentPagesViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/15.
//  Copyright © 2018 Sino. All rights reserved.
//
//评论分页界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThePostCommentPagesViewController : BaseViewController
//选定分页位置
@property (nonatomic,assign) NSInteger currPage;//评论页码
@property (nonatomic,strong) SeniorPostDataModel *postModel;
//刷新回调
@property (nonatomic,strong) void(^refreshBlock)(void);
@end

NS_ASSUME_NONNULL_END
