//
//  UIView+AddGradientRamp.m
//  SinoNews
//
//  Created by Michael on 2018/11/21.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "UIView+AddGradientRamp.h"

@implementation UIView (AddGradientRamp)
//水平方向添加渐变色
-(void)addHGradientLayer:(NSArray<UIColor*>*)colors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    GGLog(@"按钮大小:%@",NSStringFromCGRect(self.bounds));
    gradient.colors = colors;
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.locations = @[@0.0,@0.5];
    [self.layer addSublayer:gradient];
}


@end
