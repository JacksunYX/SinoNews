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
                currentFont = PFFontM(16);
                break;
            case 1:
                currentFont = PFFontM(18);
                break;
            case 2:
                currentFont = PFFontM(20);
                break;
            case 3:
                currentFont = PFFontM(22);
                break;
            case 4:
                currentFont = PFFontM(24);
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
                currentFont = PFFontL(14);
                break;
            case 1:
                currentFont = PFFontL(18);
                break;
            case 2:
                currentFont = PFFontL(20);
                break;
            case 3:
                currentFont = PFFontL(22);
                break;
                
            default:
                break;
        }
    }else{
        //没有的话就默认是中间字体
        UserSet(@"1",@"fontSize")
        [self contentFont];
    }
    return currentFont;
}

+(void)configTheme
{
    NSString *dayJsonPath = [[NSBundle mainBundle] pathForResource:@"NormalTheme" ofType:@"json"];
    
    NSString *nightJsonPath = [[NSBundle mainBundle] pathForResource:@"NightTheme" ofType:@"json"];
    
    NSString *dayJson = [NSString stringWithContentsOfFile:dayJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *nightJson = [NSString stringWithContentsOfFile:nightJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigWithJson:dayJson Tag:@"NormalTheme" ResourcesPath:nil];
    
    [LEETheme addThemeConfigWithJson:nightJson Tag:@"NightTheme" ResourcesPath:nil];
    
    [LEETheme defaultTheme:@"NormalTheme"];
}



@end
