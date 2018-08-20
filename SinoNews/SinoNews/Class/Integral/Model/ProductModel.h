//
//  ProductModel.h
//  SinoNews
//
//  Created by Michael on 2018/6/29.
//  Copyright © 2018年 Sino. All rights reserved.
//
//商品模型

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic,strong) NSString *categoryId;  //所属分类的id
@property (nonatomic,strong) NSString *categoryName;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *product_id;  //商品id
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *price;       //价格
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productType; //商品类型？
@property (nonatomic,strong) NSString *specialPrice;//特殊价格？
@property (nonatomic,strong) NSString *stock;       //库存

@end
