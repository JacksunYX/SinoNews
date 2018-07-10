//
//  NSString+AttText.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "NSString+AttText.h"

@implementation NSString (AttText)

//返回定制文字
+(NSMutableAttributedString *)leadString:(NSString *)str1 tailString:(NSString *)str2 font:(UIFont *)font color:(UIColor *)color lineBreak:(BOOL)tab
{
    NSString *totalStr;
    if (tab) {
        totalStr = [NSString stringWithFormat:@"%@\n%@",str1,str2];
    }else{
        totalStr = [str1 stringByAppendingString:str2];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary *attDic = @{
                             NSFontAttributeName:font,
                             NSForegroundColorAttributeName:color,
                             };
    [attStr addAttributes:attDic range:NSMakeRange((totalStr.length - str2.length), str2.length)];
    return attStr;
}


+(NSMutableAttributedString *)analysisHtmlString:(NSString *)string
{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                           initWithData:[string dataUsingEncoding:
                                                         NSUnicodeStringEncoding]
                                           options:@{
                                                     NSDocumentTypeDocumentAttribute:
                                                         NSHTMLTextDocumentType,
                                                     }
                                           documentAttributes:nil error:nil];
    return attrStr;
}




@end
