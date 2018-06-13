//
//  UIView+Gesture.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UIView+Gesture.h"

@implementation UIView (Gesture)

-(void)creatTapWithSelector:(SEL)sel
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:[HttpRequest currentViewController] action:sel];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

@end
