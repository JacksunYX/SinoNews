//
//  ForumDetailViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//
//版块详情列表页

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForumDetailViewController : BaseViewController
@property (nonatomic,assign) NSInteger sectionId;
@property (nonatomic,strong) NSString *icon;
@end

NS_ASSUME_NONNULL_END
