//
//  AddressTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/25.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()
{
    UILabel *username;
    UILabel *phoneNum;
    UILabel *address;
}
@end

@implementation AddressTableViewCell

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
    UILabel *defaultLabel = [UILabel new];
    defaultLabel.font = PFFontL(10);
    defaultLabel.backgroundColor = RGBA(18, 130, 238, 1);
    defaultLabel.textColor = WhiteColor;
    defaultLabel.textAlignment = NSTextAlignmentCenter;
    
    username = [UILabel new];
    username.font = PFFontL(16);
    [username addTitleColorTheme];
    
    phoneNum = [UILabel new];
    phoneNum.textAlignment = NSTextAlignmentRight;
    phoneNum.font = PFFontL(16);
    [phoneNum addTitleColorTheme];
    
    address = [UILabel new];
    address.textColor = RGBA(136, 136, 136, 1);
    address.font = PFFontL(16);
    [address addContentColorTheme];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 defaultLabel,
                                 username,
                                 phoneNum,
                                 address,
                                 
                                 ]];
    defaultLabel.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 16)
    .widthIs(27)
    .heightIs(16)
    ;
    defaultLabel.text = @"默认";
    [defaultLabel setSd_cornerRadius:@3];
    
    username.sd_layout
    .leftSpaceToView(defaultLabel, 13)
    .centerYEqualToView(defaultLabel)
    .heightIs(16)
    ;
    [username setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
//    username.text = @"张小凡";
    
    phoneNum.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(username)
    .heightIs(16)
    ;
    [phoneNum setSingleLineAutoResizeWithMaxWidth:ScreenW/3];
//    phoneNum.text = @"18772100992";
    
    address.sd_layout
    .topSpaceToView(username, 20)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 15)
    .autoHeightRatio(0)
    ;
//    address.text = @"收货地址：湖北省武汉市洪山区关山大道清江山水 2#4单元602";
    
    [self setupAutoHeightWithBottomView:address bottomMargin:10];
}

-(void)setModel:(AddressModel *)model
{
    _model = model;
    
    username.text = GetSaveString(model.consignee);
    
    phoneNum.text = [NSString stringWithFormat:@"%ld",model.mobile];
    
    address.text = GetSaveString(model.fullAddress);
}

@end
