//
//  YXLabel.h
//  SinoNews
//
//  Created by Michael on 2018/11/16.
//  Copyright © 2018 Sino. All rights reserved.
//
//自定义继承自YYLabel，目的是为了集成本地表情

#import "YYLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXLabel : YYLabel

/**
 计算label高度

 @param lineSpace 行高
 @param width 宽度
 @return 返回最终适应后的高度
 */
- (CGFloat)getLabelWithLineSpace:(CGFloat)lineSpace width:(CGFloat)width;

//解析获取h5内容
-(NSMutableAttributedString *)p_htmlChangeString:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
