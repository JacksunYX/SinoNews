//
//  StoreChildCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "StoreChildCell.h"

@interface StoreChildCell ()
{
    UIImageView *backImg;
    UIImageView *iconImg;
    
    UILabel *title;
    UILabel *subTitle;
    UILabel *bottomTitle;
    
    UILabel *rightTitle;
}
@end

@implementation StoreChildCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = WhiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    backImg = [UIImageView new];
    iconImg = [UIImageView new];
    
    title = [UILabel new];
    title.font = FontScale(15);
    
    subTitle = [UILabel new];
    subTitle.font = FontScale(12);
    subTitle.textColor = RGBA(152, 152, 152, 1);
    
    bottomTitle = [UILabel new];
    bottomTitle.font = FontScale(15);
    
    rightTitle = [UILabel new];
    rightTitle.font = FontScale(15);
    rightTitle.textColor = RGBA(18, 130, 238, 1);
    
    CGFloat lrMargin = 10; //左右间距
    [self.contentView addSubview:backImg];
    backImg.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .topEqualToView(0)
    .heightIs((ScreenW - 2 * lrMargin) * 70 / 355)
    ;
    [backImg setImage:UIImageNamed(@"store_backImg")];
    
    [backImg sd_addSubviews:@[
                              iconImg,
                              title,
                              subTitle,
                              bottomTitle,
                              rightTitle,
                              ]];
    iconImg.sd_layout
    .leftSpaceToView(backImg, 5)
    .topSpaceToView(backImg, 5)
    .bottomSpaceToView(backImg, 5)
    .widthEqualToHeight()
    ;
    [iconImg setImage:UIImageNamed(@"logo_youku")];
    
    title.sd_layout
    .leftSpaceToView(iconImg, 5)
    .topEqualToView(iconImg)
    .heightIs(15)
    ;

    [title setSingleLineAutoResizeWithMaxWidth:180 * ScaleW];
    title.text = @"优酷VIP会员卡";
    
    subTitle.sd_layout
    .leftSpaceToView(iconImg, 5)
    .centerYEqualToView(backImg)
    .heightIs(12)
    ;

    [subTitle setSingleLineAutoResizeWithMaxWidth:180 * ScaleW];
    subTitle.text = @"一个月超级会员";
    
    bottomTitle.sd_layout
    .leftSpaceToView(iconImg, 5)
    .bottomEqualToView(iconImg)
    .heightIs(15)
    ;

    [bottomTitle setSingleLineAutoResizeWithMaxWidth:180 * ScaleW];
    bottomTitle.text = @"价值1000元";
    
    rightTitle.sd_layout
    .rightSpaceToView(backImg, 10 * ScaleW)
    .centerYEqualToView(backImg)
    .widthIs(70 * ScaleW)
    .autoHeightRatio(0)
    ;
    rightTitle.text = @"550000\n积分兑换";
    
    [self setupAutoHeightWithBottomView:backImg bottomMargin:10];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    
    
}


@end
