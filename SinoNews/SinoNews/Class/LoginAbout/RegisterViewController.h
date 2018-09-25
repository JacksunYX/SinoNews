//
//  RegisterViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//
//注册

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

//注册成功回调
@property (nonatomic,copy) void (^registerSuccess)(NSString *userName,NSString *password);

@end
