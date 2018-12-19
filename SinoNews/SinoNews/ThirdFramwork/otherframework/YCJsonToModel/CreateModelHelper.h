//
//  CreateModelHelper.h
//  SinoNews
//
//  Created by Michael on 2018/12/19.
//  Copyright © 2018 Sino. All rights reserved.
//
//模型生成辅助类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateModelHelper : NSObject

/**
 生成模型导出到桌面

 @param name 模型类名
 @param data 需要转换成模型的数据
 */
+(void)generateModelWithModelName:(NSString *)name json:(id)data;

@end

NS_ASSUME_NONNULL_END
