//
//  GetImageSizeTool.h
//  SinoNews
//
//  Created by Michael on 2018/9/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImageSizeTool : NSObject

singleton_interface(GetImageSizeTool)

+(CGSize)downloadImageSizeWithURL:(id)imageURL;

@end
