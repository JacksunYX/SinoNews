//
//  GetCurrentFont.m
//  SinoNews
//
//  Created by Michael on 2018/7/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "GetCurrentFont.h"

@implementation GetCurrentFont

+(UIFont *)titleFont
{
    UIFont *currentFont;
    if (UserGet(@"fontSize")) {
        switch ([UserGet(@"fontSize") integerValue]) {
            case 0:
                currentFont = PFFontL(12);
                break;
            case 1:
                currentFont = PFFontL(14);
                break;
            case 2:
                currentFont = PFFontL(16);
                break;
            case 3:
                currentFont = PFFontL(18);
                break;
            case 4:
                currentFont = PFFontL(20);
                break;
                
            default:
                break;
        }
    }else{
        //没有的话就默认是中间字体
        UserSet(@"2",@"fontSize")
        [self titleFont];
    }
    return currentFont;
}

+(UIFont *)contentFont
{
    UIFont *currentFont;
    if (UserGet(@"fontSize")) {
        switch ([UserGet(@"fontSize") integerValue]) {
            case 0:
                currentFont = PFFontL(12);
                break;
            case 1:
                currentFont = PFFontL(13);
                break;
            case 2:
                currentFont = PFFontL(14);
                break;
            case 3:
                currentFont = PFFontL(15);
                break;
            case 4:
                currentFont = PFFontL(16);
                break;
                
            default:
                break;
        }
    }else{
        //没有的话就默认是中间字体
        UserSet(@"2",@"fontSize")
        [self titleFont];
    }
    return currentFont;
}





@end
