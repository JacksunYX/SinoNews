//
//  VersionCheckHelper.h
//  SinoNews
//
//  Created by Michael on 2018/8/23.
//  Copyright © 2018年 Sino. All rights reserved.
//
//版本检测类

#import <Foundation/Foundation.h>

typedef void(^success)(id response);

@interface VersionCheckHelper : NSObject


/**
 检测版本

 @param successBlock 回调
 @param pop 是否直接弹框
 */
+(void)requestToCheckVersion:(success)successBlock popUpdateView:(BOOL)pop;



@end
