//
//  GetImageSizeTool.h
//  SinoNews
//
//  Created by Michael on 2018/9/10.
//  Copyright © 2018年 Sino. All rights reserved.
//
//不下载图片并得到图片大小

#import <Foundation/Foundation.h>

@interface GetImageSizeTool : NSObject

singleton_interface(GetImageSizeTool)

+(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
