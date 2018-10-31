//
//  PostingListViewController.h
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//
//我的发帖列表/草稿列表

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostingListViewController : BaseViewController
//0默认为帖子，1为草稿
@property (nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
