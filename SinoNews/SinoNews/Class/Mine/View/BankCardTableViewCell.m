//
//  BankCardTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/9/27.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BankCardTableViewCell.h"

@interface BankCardTableViewCell ()
{
    UILabel *bankName;  //银行名
    UILabel *cardType;  //卡类型
    UILabel *cardNum;   //卡号
}
@end

@implementation BankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    UIImageView *backImg = [UIImageView new];
    bankName = [UILabel new];
    cardType = [UILabel new];
    cardNum = [UILabel new];
    
    bankName.textColor = WhiteColor;
    cardType.textColor = HexColorAlpha(#FFFFFF, 0.24);
    cardNum.textColor = WhiteColor;
    
    bankName.font = PFFontL(16);
    cardType.font = PFFontL(13);
    cardNum.font = PFFontL(24);
    
    [self.contentView addSubview:backImg];
    
    backImg.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs((ScreenW - 20)*100/355)
    ;
    backImg.image = UIImageNamed(@"bankCard_backImg");
    
    [backImg sd_addSubviews:@[
                              bankName,
                              cardType,
                              cardNum,
                              ]];
    bankName.sd_layout
    .topSpaceToView(backImg, 15)
    .leftSpaceToView(backImg, 20)
    .heightIs(16)
    ;
    [bankName setSingleLineAutoResizeWithMaxWidth:200];
    bankName.text = @"农业银行";
    
    cardType.sd_layout
    .leftSpaceToView(backImg, 20)
    .centerYEqualToView(backImg)
    .heightIs(14)
    ;
    [cardType setSingleLineAutoResizeWithMaxWidth:200];
    cardType.text = @"储蓄卡";
    
    cardNum.sd_layout
    .leftSpaceToView(backImg, 20)
    .rightSpaceToView(backImg, 20)
    .bottomSpaceToView(backImg, 15)
    .heightIs(20)
    ;
    cardNum.text = @"**** **** **** 7678";
    
    [self setupAutoHeightWithBottomView:backImg bottomMargin:15];
}

-(void)setModel:(BankCardModel *)model
{
    
}

@end
