//
//  LoginViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/15.
//  Copyright © 2018年 Sino. All rights reserved.
//
//登陆

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,assign) BOOL normalBack;

@property (nonatomic,copy) void (^backHandleBlock)(void) ;



@end
