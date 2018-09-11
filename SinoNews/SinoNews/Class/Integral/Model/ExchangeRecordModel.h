//
//  ExchangeRecordModel.h
//  SinoNews
//
//  Created by Michael on 2018/8/1.
//  Copyright © 2018年 Sino. All rights reserved.
//
//积分兑换记录

#import <Foundation/Foundation.h>

@interface ExchangeRecordModel : NSObject

@property(nonatomic,strong) NSString *consignee;    //收件人
@property(nonatomic,strong) NSString *mobile;       //联系方式
@property(nonatomic,strong) NSString *fullAddress;  //收货地址
@property(nonatomic,strong) NSString *coupon;       //虚拟货物的券号
@property(nonatomic,strong) NSString *createTime;   //时间
@property(nonatomic,strong) NSString *orderNo;      //订单号
@property(nonatomic,assign) NSInteger price;        //价格
@property(nonatomic,assign) NSInteger productId;    //id
@property(nonatomic,strong) NSString *productImage; //图片
@property(nonatomic,strong) NSString *productName;  //名称
@property(nonatomic,assign) NSInteger productType;  //商品类型(0实物 1虚拟)
@property(nonatomic,strong) NSString *status;       //订单状态

@end
