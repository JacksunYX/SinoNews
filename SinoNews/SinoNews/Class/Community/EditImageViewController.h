//
//  EditImageViewController.h
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//
//高级发帖-编辑已选图片、描述

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditImageViewController : BaseViewController
//传递过来的model
@property (nonatomic,strong) SeniorPostingAddElementModel *model;
//完成回调
@property (nonatomic,copy) void(^finishBlock)(SeniorPostingAddElementModel *finishModel);
@end

NS_ASSUME_NONNULL_END
