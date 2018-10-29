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
    UIView *topView;
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
    title.font = PFFontL(14);
    title.textColor = HexColor(#161A24);
    [self addSubview:title];
    
    title.sd_layout
    .leftSpaceToView(self, 10)
    .centerYEqualToView(self)
    .rightSpaceToView(self, 20)
    .heightIs(20)
    ;
    
    topView = [UIView new];
    topView.backgroundColor = WhiteColor;
    topView.hidden = YES;
    [self addSubview:topView];
    topView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(self, 10)
    ;
    
    UILabel *noticeLabel = [UILabel new];
    UIImage *icon = [UIImageView new];
}

-(void)setData:(NSDictionary *)model
{
    title.text = @"";
    if ([model.allKeys containsObject:@"unFold"]) {
        BOOL unFold = [model[@"unFold"] boolValue];
        topView.hidden = unFold;
        [topView whenTap:^{
            
        }];
    }else if (model.allKeys.count>0) {
        title.text = [NSString stringWithFormat:@"%@（%ld）",model[@"name"],[model[@"num"] integerValue]];
    }
}

@end
