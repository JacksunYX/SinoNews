//
//  HomePageThirdKindCell.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageThirdKindCell.h"

@interface HomePageThirdKindCell ()
{
    UILabel *title;
    UIImageView *img;
    
}
@end

@implementation HomePageThirdKindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
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
    title = [UILabel new];
    title.font = FontScale(16);
    title.textColor = HexColor(#323232);
    
    img = [UIImageView new];
    img.userInteractionEnabled = YES;
    img.backgroundColor = Arc4randomColor;
    
    UILabel *label1 = [UILabel new];
    label1.font = FontScale(11);
    label1.textColor = HexColor(#1282EE);
    label1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label2 = [UILabel new];
    label2.font = FontScale(11);
    label2.textColor = HexColor(#1282EE);
    label2.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView sd_addSubviews:@[
                                       title,
                                       img,
                                       label1,
//                                       label2,
                                       
                                       ]];
    
    CGFloat lrMargin = 10;  //左右间距
    CGFloat tbMargin = 10;  //上下间距
    
    //布局
    title.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(self.contentView, tbMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    title.text = @"上班族注意啦！用贝壳app租房～没想到这么便宜上班族注意啦！用贝壳app租房～没想到这么便宜上班族注意啦！用贝壳app租房～没想到这么便宜";
    
    CGFloat imgW = (ScreenW - lrMargin*2);
    CGFloat imgH = imgW * 160.0 / 355;
    img.sd_layout
    .topSpaceToView(title, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
//    [img  setSd_cornerRadius:@4];
    [img cornerWithRadius:4];
    
    label1.sd_layout
    .rightSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(img, tbMargin)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 11 * 3)
    ;
    LRViewBorderRadius(label1, 2, 1, HexColor(#1282EE));
    label1.text = @"广告";
    
    label2.sd_layout
    .leftSpaceToView(label1, lrMargin)
    .centerYEqualToView(label1)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 11 * 5)
    ;
    LRViewBorderRadius(label2, 2, 1, HexColor(#1282EE));
    label2.text = @"立即下载";
    
    [self setupAutoHeightWithBottomView:label1 bottomMargin:tbMargin];
}

-(void)setModel:(ADModel *)model
{
    _model = model;
    title.text = GetSaveString(model.itemTitle);
}








@end
