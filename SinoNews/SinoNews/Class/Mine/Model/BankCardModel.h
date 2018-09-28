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
@property (nonatomic,strong) NSString *cardNo; //卡号
@property (nonatomic,strong) NSString *cardholderName;  //持卡人
@property (nonatomic,strong) NSString *depositBankName; //开户行
@property (nonatomic,assign) NSInteger cardId;
@end

NS_ASSUME_NONNULL_END
