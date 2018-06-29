//
//  ProductModel.m
//  SinoNews
//
//  Created by Michael on 2018/6/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"product_id" : @"id"};
}

@end
