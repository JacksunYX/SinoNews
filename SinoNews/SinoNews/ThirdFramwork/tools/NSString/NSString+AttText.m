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

//根据文本生成自定义的富文本图片标签
+(NSMutableAttributedString *)getLabelWithString:(NSString *)string font:(CGFloat)fontSize textColor:(UIColor *)textcolor backColor:(UIColor *)backcolor corner:(CGFloat)cornerSize
{
    CGFloat aaW = 12*string.length + 5;
    //创建标签Label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, aaW*3, 16*3)];
    label.text = string;
    label.textColor = textcolor;
    label.backgroundColor = backcolor;
    label.font = [UIFont boldSystemFontOfSize:fontSize*3];;
    label.textAlignment = NSTextAlignmentCenter;
    label.clipsToBounds = YES;
    label.layer.cornerRadius = 3*cornerSize;
    //调用方法，转化成Image
    UIImage *image = [UIImage imageWithUIView:label];
    //创建Image的富文本格式
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.bounds = CGRectMake(0, -2, aaW, 18); //这个-2是为了调整下标签跟文字的位置
    attach.image = image;
    //添加到富文本对象里
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    return imageStr.mutableCopy;
}

@end
