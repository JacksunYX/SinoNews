//
//  BindingDataViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//绑定手机/邮箱

#import <UIKit/UIKit.h>

@interface BindingDataViewController : BaseViewController

@property (nonatomic,assign) NSInteger bindingType;
@property (nonatomic,assign) BOOL isUpdate; //是更新还是直接设置

@end
