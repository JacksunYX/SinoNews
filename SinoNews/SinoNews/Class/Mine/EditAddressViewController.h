//
//  EditAddressViewController.h
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//
//编辑地址/添加新地址

#import <UIKit/UIKit.h>

@class AddressModel;
@interface EditAddressViewController : UIViewController

@property (nonatomic,strong) AddressModel *model;

@property (nonatomic,copy) void(^refreshBlock)(void);

@end
