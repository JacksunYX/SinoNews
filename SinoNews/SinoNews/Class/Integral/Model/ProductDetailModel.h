//
//  ProductDetailModel.h
//  SinoNews
//
//  Created by Michael on 2018/7/4.
//  Copyright © 2018年 Sino. All rights reserved.
//
//商品详情模型

#import <Foundation/Foundation.h>

@interface ProductDetailModel : NSObject
@property(nonatomic,assign) NSInteger categoryId;
@property(nonatomic,strong) NSString *createTime;
@property(nonatomic,assign) NSInteger creator;
@property(nonatomic,strong) NSString *editTime;
@property(nonatomic,assign) NSInteger editor;
@property(nonatomic,strong) NSString *imageUrl;
@property(nonatomic,assign) NSInteger price;
@property(nonatomic,strong) NSString *productDescription;
@property(nonatomic,assign) NSInteger productId;
@property(nonatomic,strong) NSString *productName;
@property(nonatomic,assign) NSInteger productType;
@property(nonatomic,assign) NSInteger specialPrice;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSInteger stock;
@end
