//
//  HomePageSecondKindCell.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageSecondKindCell.h"

@interface HomePageSecondKindCell ()
{
    UILabel *title;
    UIImageView *imgL;
    UIImageView *imgC;
    UIImageView *imgR;
    UILabel *bottomLabel;
    UILabel *typeLabel;
}
@end

@implementation HomePageSecondKindCell

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
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    CGFloat lrMargin = 10;  //左右间距
    CGFloat imgMargin = 5;  //图片间距
    CGFloat tbMargin = 10;  //上下间距
    
    title = [UILabel new];
    title.font = FontScale(16);
    title.textColor = HexColor(#323232);
    
    imgL = [UIImageView new];
    imgL.userInteractionEnabled = YES;
    imgL.backgroundColor = Arc4randomColor;
    imgC = [UIImageView new];
    imgC.userInteractionEnabled = YES;
    imgC.backgroundColor = Arc4randomColor;
    imgR = [UIImageView new];
    imgR.userInteractionEnabled = YES;
    imgR.backgroundColor = Arc4randomColor;
    
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(11);
    bottomLabel.textColor = HexColor(#989898);
    
    typeLabel = [UILabel new];
    typeLabel.font = FontScale(11);
    typeLabel.backgroundColor = HexColor(#1282EE);
    typeLabel.textColor = WhiteColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView sd_addSubviews:@[
                                       title,
                                       imgL,
                                       imgC,
                                       imgR,
                                       bottomLabel,
                                       typeLabel,
                                       
                                       ]];
    title.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(self.contentView, tbMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .autoHeightRatio(0)
    ;
//    typeLabel.text = @"专题";
    [title setMaxNumberOfLinesToShow:2];
//    title.text = [@"        " stringByAppendingString:@"发改委 ：多个经济体货币纷纷倒在美元魔掌以 后，美元屠刀或正在伸向欧元区"];
    
    //图片宽度
    CGFloat imgW = (ScreenW - lrMargin*2 - imgMargin*2)/3;
//    CGFloat imgH = imgW * 90.0 / 117;
    CGFloat imgH = imgW;
    imgL.sd_layout
    .topSpaceToView(title, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgL setSd_cornerRadius:@4];
//    [imgL cornerWithRadius:4];
    
    imgC.sd_layout
    .topEqualToView(imgL)
    .leftSpaceToView(imgL, imgMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgC setSd_cornerRadius:@4];
//    [imgC cornerWithRadius:4];
    
    imgR.sd_layout
    .topEqualToView(imgC)
    .leftSpaceToView(imgC, imgMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgR setSd_cornerRadius:@4];
//    [imgR cornerWithRadius:4];
    
    bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(imgL, tbMargin)
    .autoHeightRatio(0)
    ;
    [bottomLabel setMaxNumberOfLinesToShow:1];
//    NSString *str1 = [@"" stringByAppendingString:@""];
//    NSString *str2 = [@"环球国际时报" stringByAppendingString:@"  "];
//    NSString *str3 = [@"12321" stringByAppendingString:@" 阅 "];
//    NSString *str4 = [@"812" stringByAppendingString:@" 评"];
//    NSString *totalStr = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
//    bottomLabel.text = totalStr;
    
    typeLabel.sd_layout
    .leftEqualToView(title)
//    .topEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 16 + 10)
    ;
//    [typeLabel setSd_cornerRadius:@2];
    [typeLabel cornerWithRadius:2];
//    typeLabel.text = @"专题";
    
    [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];
    
}

-(void)setModel:(HomePageModel *)model
{
    _model = model;
    
    
    NSString *labelName = GetSaveString(model.labelName);
    if (kStringIsEmpty(labelName)) {
        title.text = GetSaveString(model.itemTitle);
        typeLabel.hidden = YES;
    }else{
        title.text = [@"        " stringByAppendingString:GetSaveString(model.itemTitle)];
        typeLabel.hidden = NO;
    }
    
    if (model.images.count>0) {
        NSString *imgStr = GetSaveString(model.images[0]);
        [imgL sd_setImageWithURL:UrlWithStr(imgStr)];
    }else{
        imgL.image = nil;
    }
    
    if (model.images.count>1) {
        NSString *imgStr = GetSaveString(model.images[1]);
        [imgC sd_setImageWithURL:UrlWithStr(imgStr)];
    }else{
        imgC.image = nil;
    }
    
    if (model.images.count>2) {
        NSString *imgStr = GetSaveString(model.images[2]);
        [imgR sd_setImageWithURL:UrlWithStr(imgStr)];
    }else{
        imgR.image = nil;
    }
    typeLabel.text = GetSaveString(model.labelName);
    NSString *str1 = @"";
    NSString *str2 = [GetSaveString(model.username) stringByAppendingString:@"  "];
    NSString *str3 = [[NSString stringWithFormat:@"%ld",model.viewCount] stringByAppendingString:@" 阅  "];
    NSString *str4 = [[NSString stringWithFormat:@"%ld",model.commentCount] stringByAppendingString:@" 评"];
    NSString *totalStr = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:totalStr];
    bottomLabel.attributedText = attString;
}







@end
