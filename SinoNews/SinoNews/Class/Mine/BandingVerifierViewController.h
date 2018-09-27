//
//  BandingVerifierViewController.h
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//
//验证身份以绑定支付宝或银行卡

#import "BaseViewController.h"
#import "BandingAlipayViewController.h"
#import "BandingBankCardViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BandingVerifierViewController : BaseViewController

//0为支付宝，1为银行卡
@property (nonatomic,assign) NSInteger verifierType;

@end

NS_ASSUME_NONNULL_END
