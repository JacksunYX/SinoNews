//
//  ReadPostChildViewController.h
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//
//读帖子界面

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadPostChildViewController : BaseViewController
//默认不是用户关注版块的帖子
@property (nonatomic,assign) BOOL isAttentionPost;
@property (nonatomic,strong) MainSectionModel *model;
@end

NS_ASSUME_NONNULL_END
