//
//  ExchangeRecordCell.m
//  SinoNews
//
//  Created by Michael on 2018/8/1.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ExchangeRecordCell.h"

@interface ExchangeRecordCell ()
{
    UIImageView *productImage;    //商品图标
    UILabel *productName;   //商品名称
    UILabel *time;          //操作时间
    UILabel *integral;      //积分
}
@end

@implementation ExchangeRecordCell

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
        self.backgroundColor = WhiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIView *leftLine = [UIView new];
    
    UIView *rightLine = [UIView new];
    
    UIView *bottomLine = [UIView new];
    
    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UITableViewCell *)item setBackgroundColor:value];
        
        leftLine.backgroundColor = CutLineColor;
        rightLine.backgroundColor = CutLineColor;
        bottomLine.backgroundColor = CutLineColor;
        if (UserGetBool(@"NightMode")) {
            
            leftLine.backgroundColor = CutLineColorNight;
            rightLine.backgroundColor = CutLineColorNight;
            bottomLine.backgroundColor = CutLineColorNight;
        }
    });
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 leftLine,
                                 rightLine,
                                 bottomLine,
                                 ]];
    CGFloat lrMargin = 10;
    CGFloat labelWid = (ScreenW - 2 * lrMargin)/4;
    leftLine.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    rightLine.sd_layout
    .rightSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    bottomLine.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .rightSpaceToView(fatherView, lrMargin)
    .bottomEqualToView(fatherView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    
    UIView *leftView = [UIView new];
    UIView *centerView = [UIView new];
    UIView *rightView = [UIView new];
    
//    [leftView addBakcgroundColorTheme];
//    [centerView addBakcgroundColorTheme];
//    [rightView addBakcgroundColorTheme];
    leftView.backgroundColor = ClearColor;
    centerView.backgroundColor = ClearColor;
    rightView.backgroundColor = ClearColor;
    
    [fatherView sd_addSubviews:@[
                                       leftView,
                                       centerView,
                                       rightView,
                                       ]];
    leftView.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid * 2)
    ;
    
    centerView.sd_layout
    .leftSpaceToView(leftView, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
    
    rightView.sd_layout
    .rightSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
    
    //添加显示控件
    productImage = [UIImageView new];
    
    productName = [UILabel new];
    productName.font = PFFontL(13);
    productName.textColor = HexColor(#1282EE);
    productName.textAlignment = NSTextAlignmentCenter;
    productName.numberOfLines = 3;
    
    [leftView sd_addSubviews:@[
                               productImage,
                               productName,
                               
                               ]];
    productImage.sd_layout
    .leftSpaceToView(leftView, 10)
    .topSpaceToView(leftView, 15)
    .bottomSpaceToView(leftView, 15)
    .widthEqualToHeight()
    ;
//    productImage.backgroundColor = Arc4randomColor;
    
    productName.sd_layout
    .topEqualToView(productImage)
    .bottomEqualToView(productImage)
    .leftSpaceToView(productImage, 10)
    .rightSpaceToView(leftView, 10)
//    .autoHeightRatio(0)
    ;
//    [productName setMaxNumberOfLinesToShow:3];
    
    time = [UILabel new];
    time.font = PFFontL(12);
    time.textColor = RGBA(152, 152, 152, 1);
    [centerView addSubview:time];
    time.sd_layout
//    .topSpaceToView(centerView, 15)
    .centerYEqualToView(centerView)
    .leftSpaceToView(centerView, 10)
    .rightSpaceToView(centerView, 10)
    .autoHeightRatio(0)
    ;
    [time setMaxNumberOfLinesToShow:3];
    
    integral = [UILabel new];
    integral.font = PFFontL(13);
    integral.textColor = RGBA(152, 152, 152, 1);
    integral.textAlignment = NSTextAlignmentCenter;
    [rightView addSubview:integral];
    integral.sd_layout
//    .topSpaceToView(rightView, 15)
    .centerYEqualToView(rightView)
    .leftSpaceToView(rightView, 10)
    .rightSpaceToView(rightView, 10)
    .autoHeightRatio(0)
    ;
    [integral setMaxNumberOfLinesToShow:3];
    
}

-(void)setModel:(ExchangeRecordModel *)model
{
    _model = model;
    [productImage sd_setImageWithURL:UrlWithStr(GetSaveString(model.productImage)) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    productName.text = GetSaveString(model.productName);
    time.text = GetSaveString(model.createTime);
//    integral.text = [NSString stringWithFormat:@"%ld",model.price];
    integral.text = GetSaveString(model.status);
}

@end
