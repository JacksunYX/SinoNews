//
//  UniversalMethod.h
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADModel;
@interface UniversalMethod : NSObject

/**
 根据广告模型跳转到不同界面

 @param model 模型
 */
+(void)jumpWithADModel:(ADModel *)model;






@end
