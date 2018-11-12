//
//  AddNewContentViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-新增文本控制器

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddNewContentViewController : BaseViewController
//完成回调
@property (nonatomic,copy) void(^finishBlock)(NSString *inputContent);
//传递过来的content
@property (nonatomic,strong) NSString *lastContent;
@end

NS_ASSUME_NONNULL_END
