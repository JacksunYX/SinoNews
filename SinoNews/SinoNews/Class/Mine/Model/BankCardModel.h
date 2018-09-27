//
//  BankCardModel.h
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BankCardModel : NSObject

@property (nonatomic,strong) NSString *bankName;//银行名
@property (nonatomic,strong) NSString *cardType;//卡类型
@property (nonatomic,strong) NSString *cardNum; //卡号

@end

NS_ASSUME_NONNULL_END
