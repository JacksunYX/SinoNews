//
//  BankCardViewController.h
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//
//用户绑定的银行卡

#import <UIKit/UIKit.h>
#import "BankCardTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface BankCardViewController : UIViewController
@property (strong, nonatomic) NSMutableArray <BankCardModel *>*dataSource;
@end

NS_ASSUME_NONNULL_END
