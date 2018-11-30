//
//  YXLabel.m
//  SinoNews
//
//  Created by Michael on 2018/11/16.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "YXLabel.h"

@implementation YXLabel

-(instancetype)init
{
    if (self == [super init]) {
        self.displaysAsynchronously = YES;
        self.numberOfLines = 0;
        //设置本地表情识别
        self.textParser = BrowsNewsSingleton.singleton.parser;
    }
    return self;
}

//计算label高度
- (CGFloat)getLabelWithLineSpace:(CGFloat)lineSpace width:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = self.textAlignment;
//    paraStyle.lineSpacing = lineSpace;
//    paraStyle.hyphenationFactor = 1.0;
    //首行缩进
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
    //头尾缩进
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{
                          NSFontAttributeName:self.font,
                NSParagraphStyleAttributeName:paraStyle,
//                          NSKernAttributeName:@1.0f,
                          };
    
    //创建富文本并将上面的段落样式加入
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attrString addAttributes:dic range:NSMakeRange(0, attrString.length)];
    self.attributedText = attrString;
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    //计算的大小可能刚刚够排版的高度，最好取整后加1，宁愿大一点点，不能小了导致无法显示完全
    return ceil(size.height) + 1;
    
}

@end
