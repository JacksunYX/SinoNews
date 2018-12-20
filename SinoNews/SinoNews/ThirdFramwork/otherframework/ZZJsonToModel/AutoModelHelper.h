//
//  AutoModelHelper.h
//  SinoNews
//
//  Created by Michael on 2018/12/20.
//  Copyright © 2018 Sino. All rights reserved.
//
//自动生成模型类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoModelHelper : NSObject

/**
 自动生成模型输出到桌面

 @param json 需要解析为模型的数据
 @param name 将要转换为模型的类名
 */
+(void)generateModelWithJsonData:(id)json modelName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
