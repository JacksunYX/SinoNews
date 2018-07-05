//
//  AddressModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//
//地址模型

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property(nonatomic,assign)NSInteger addressId;     //地址id
@property(nonatomic,strong)NSString *consignee;     //收件人姓名
@property(nonatomic,strong)NSString *createTime;    //添加时间
@property(nonatomic,assign)NSInteger defaultAddress;//别名：家或公司等
@property(nonatomic,strong)NSString *fullAddress;   //地址
@property(nonatomic,assign)NSInteger mobile;        //手机号
@property(nonatomic,assign)NSInteger userId;        //用户id
@property(nonatomic,strong)NSString *username;      //用户昵称
@end
