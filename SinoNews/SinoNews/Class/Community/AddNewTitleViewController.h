//
//  AddNewTitleViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-新增标题控制器

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNewTitleViewController : BaseViewController
//完成回调
@property (nonatomic,copy) void(^finishBlock)(NSString *inputTitle);
//传递过来的title
@property (nonatomic,strong) NSString *lastTitle;

@end

NS_ASSUME_NONNULL_END
