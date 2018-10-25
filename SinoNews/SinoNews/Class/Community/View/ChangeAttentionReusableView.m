//
//  ChangeAttentionReusableView.m
//  SinoNews
//
//  Created by Michael on 2018/10/25.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ChangeAttentionReusableView.h"

NSString *const ChangeAttentionReusableViewID = @"NSString *const ChangeAttentionReusableViewID";

@interface ChangeAttentionReusableView ()
{
    UILabel *title;
}
@end

@implementation ChangeAttentionReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    title = [UILabel new];
    title.font = PFFontR(14);
    title.textColor = LightGrayColor;
    [self addSubview:title];
    
    title.sd_layout
    .leftSpaceToView(self, 20)
    .centerYEqualToView(self)
    .rightSpaceToView(self, 20)
    .heightIs(20)
    ;
}

-(void)setData:(NSDictionary *)model
{
    if (model.allKeys.count>0) {
        title.text = [NSString stringWithFormat:@"%@(%ld)",model[@"name"],[model[@"num"] integerValue]];
    }else{
        title.text = @"";
    }
}

@end
