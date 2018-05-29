//
//  UIBarButtonItem+integration.h
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (integration)

+(UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title;


+(UIBarButtonItem *)itemBottomWithTarget:(id)target Action:(SEL)action image:(NSString *)image hightimage:(NSString *)hightimage andTitle:(NSString *)title;


@end
