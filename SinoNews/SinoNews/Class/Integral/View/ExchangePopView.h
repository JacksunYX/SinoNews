//
//  ExchangePopView.h
//  SinoNews
//
//  Created by Michael on 2018/8/1.
//  Copyright © 2018年 Sino. All rights reserved.
//
//兑换记录的弹窗

#import <UIKit/UIKit.h>
#import "ExchangeRecordModel.h"

@interface ExchangePopView : UIView

+(void)showWithData:(ExchangeRecordModel *)model;

@end
