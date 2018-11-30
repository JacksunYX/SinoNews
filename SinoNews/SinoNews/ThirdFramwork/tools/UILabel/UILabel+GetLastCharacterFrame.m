//
//  UILabel+GetLastCharacterFrame.m
//  SinoNews
//
//  Created by Michael on 2018/11/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "UILabel+GetLastCharacterFrame.h"

@implementation UILabel (GetLastCharacterFrame)

-(CGPoint)getLastCharacterFrame
{
    //最后一个点
    CGPoint lastPoint = CGPointMake(0, 0);
    //
    CGSize sz = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    CGSize linesSz = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sz.width, sz.height);
    if(sz.width <= linesSz.width) //判断是否折行
        
    {
        
        lastPoint = CGPointMake(self.frame.origin.x + sz.width,self.frame.origin.y);
        
    }
    
    else
        
    {
        
        lastPoint = CGPointMake(self.frame.origin.x + (int)sz.width % (int)linesSz.width,linesSz.height - sz.height);
        
    }
    GGLog(@"最后一个字符的point：%@",NSStringFromCGPoint(lastPoint));
    return lastPoint;
}

@end
