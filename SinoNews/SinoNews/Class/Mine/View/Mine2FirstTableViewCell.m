//
//  Mine2FirstTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/26.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "Mine2FirstTableViewCell.h"

NSString *const Mine2FirstTableViewCellID = @"Mine2FirstTableViewCellID";

@interface Mine2FirstTableViewCell ()
{
    UILabel *leftInteger;
    UILabel *leftSub;
    
    UILabel *centerInteger;
    UILabel *centerSub;
    
    KCGradientLabel *rightLabel;
}
@end

@implementation Mine2FirstTableViewCell

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
    CGFloat TBX = 5;
    UIImageView *backView = [UIImageView new];
    backView.userInteractionEnabled = YES;
    [self.contentView addSubview:backView];
    
    backView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, TBX)
    .heightIs(75)
    ;
    [backView updateLayout];
    backView.lee_theme.LeeConfigImage(@"mine_Shadow_middle");
    
    UIView *leftView = [UIView new];
    UIView *centerView = [UIView new];
    UIView *rightView = [UIView new];
    
    [backView sd_addSubviews:@[
                               leftView,
                               centerView,
                               rightView,
                               ]];
    leftView.sd_layout
    .leftEqualToView(backView)
    .topEqualToView(backView)
    .bottomEqualToView(backView)
    .widthRatioToView(backView, 1/3.0)
    ;
    
    centerView.sd_layout
    .leftSpaceToView(leftView, 0)
    .topEqualToView(backView)
    .bottomEqualToView(backView)
    .widthRatioToView(backView, 1/3.0)
    ;
    
    rightView.sd_layout
    .rightEqualToView(backView)
    .topEqualToView(backView)
    .bottomEqualToView(backView)
    .widthRatioToView(backView, 1/3.0)
    ;
    
    [self addLeftView:leftView];
    [self addCenterView:centerView];
    [self addRightView:rightView];
    
    [self setupAutoHeightWithBottomView:backView bottomMargin:TBX];
    
}

//添加视图到
-(void)addLeftView:(UIView *)fatherView
{
    leftInteger = [UILabel new];
    leftInteger.font = PFFontR(16);
    [leftInteger addTitleColorTheme];
    
    leftSub = [UILabel new];
    leftSub.font = PFFontL(12);
    [leftSub addContentColorTheme];
    
    [fatherView sd_addSubviews:@[
                                 leftSub,
                                 leftInteger,
                                 ]];
    
    leftSub.sd_layout
    .centerXEqualToView(fatherView)
    .bottomSpaceToView(fatherView, 20)
    .heightIs(14)
    ;
    [leftSub setSingleLineAutoResizeWithMaxWidth:fatherView.width];
    leftSub.text = @"今日获得积分";
    
    leftInteger.sd_layout
    .centerXEqualToView(fatherView)
    .bottomSpaceToView(leftSub, 10)
    .heightIs(18)
    ;
    [leftInteger setSingleLineAutoResizeWithMaxWidth:fatherView.width];
    leftInteger.text = @"40";
}

-(void)addCenterView:(UIView *)fatherView
{
    centerInteger = [UILabel new];
    centerInteger.font = PFFontR(16);
    [centerInteger addTitleColorTheme];
    
    centerSub = [UILabel new];
    centerSub.font = PFFontL(12);
    [centerSub addContentColorTheme];
    
    [fatherView sd_addSubviews:@[
                                 centerSub,
                                 centerInteger,
                                 ]];
    
    centerSub.sd_layout
    .centerXEqualToView(fatherView)
    .bottomSpaceToView(fatherView, 20)
    .heightIs(14)
    ;
    [centerSub setSingleLineAutoResizeWithMaxWidth:fatherView.width];
    centerSub.text = @"今日还可获取";
    
    centerInteger.sd_layout
    .centerXEqualToView(fatherView)
    .bottomSpaceToView(centerSub, 10)
    .heightIs(18)
    ;
    [centerInteger setSingleLineAutoResizeWithMaxWidth:fatherView.width];
    centerInteger.text = @"500";
}

-(void)addRightView:(UIView *)fatherView
{
    rightLabel = [KCGradientLabel new];
    [fatherView addSubview:rightLabel];
    rightLabel.sd_layout
    .centerYEqualToView(fatherView)
    .centerXEqualToView(fatherView)
    .heightIs(18)
    .widthIs(50)
    ;
    [rightLabel updateLayout];
    rightLabel.text = @"赚积分";
    rightLabel.gradientColors = @[HexColor(#CA65E7),HexColor(#2E199C)];
    rightLabel.font = PFFontR(15);
    rightLabel.gradientDirection = KCGradientLabelGradientDirectionHorizontal;
}

-(void)setData:(NSDictionary *)data
{
    
}

@end
