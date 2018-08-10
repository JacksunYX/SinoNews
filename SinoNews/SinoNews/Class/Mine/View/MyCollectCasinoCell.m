//
//  MyCollectCasinoCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyCollectCasinoCell.h"
@interface MyCollectCasinoCell ()
{
    UIImageView *img;
    UILabel *title;
    UILabel *detail;    //详情
    UILabel *webUrl;    //官网
    UILabel *introduce;
}
@end
@implementation MyCollectCasinoCell

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
        UIView *backView = [UIView new];
        backView.backgroundColor = ClearColor;
        self.selectedBackgroundView = backView;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
//    UIImageView *star = [UIImageView new];
    
    img = [UIImageView new];
    
    title = [UILabel new];
    title.font = PFFontR(16);
    [title addTitleColorTheme];
    
    webUrl = [UILabel new];
    webUrl.font = PFFontL(15);
    webUrl.textAlignment = NSTextAlignmentCenter;
    webUrl.textColor = HexColor(#1282EE);
    webUrl.layer.borderColor = HexColor(#1282EE).CGColor;
    webUrl.layer.borderWidth = 1;
    
    detail = [UILabel new];
    detail.font = PFFontL(15);
    detail.textAlignment = NSTextAlignmentCenter;
    detail.textColor = HexColor(#1282EE);
    detail.layer.borderColor = HexColor(#1282EE).CGColor;
    detail.layer.borderWidth = 1;
    
    UIView *sepLine = [UIView new];
    [sepLine addCutLineColor];
    
    introduce = [UILabel new];
    introduce.font = PFFontL(15);
//    introduce.textColor = RGBA(105, 105, 105, 1);
    [introduce addContentColorTheme];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
//                                 star,
                                 img,
                                 webUrl,
                                 detail,
                                 title,
                                 sepLine,
//                                 introduce,
                                 ]];
//    star.sd_layout
//    .leftSpaceToView(fatherView, 10)
//    .topSpaceToView(fatherView, 10)
//    .widthIs(54)
//    .heightIs(61)
    ;
//    star.image = UIImageNamed(@"game_sixStar");
    
    img.sd_layout
//    .centerXEqualToView(fatherView)
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(50)
    .heightEqualToWidth()
    ;
//    img.image = UIImageNamed(@"user_icon");
    [img setSd_cornerRadius:@25];
    
    webUrl.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(58)
    .heightIs(22)
    ;
    webUrl.text = @"官网";
    [webUrl setSd_cornerRadius:@4];
    
    detail.sd_layout
    .rightSpaceToView(webUrl, 10)
    .centerYEqualToView(fatherView)
    .widthIs(58)
    .heightIs(22)
    ;
    detail.text = @"详情";
    [detail setSd_cornerRadius:@4];
    
    title.sd_layout
    .leftSpaceToView(img, 9)
    .centerYEqualToView(img)
    .heightIs(16)
//    .rightSpaceToView(fatherView, 10)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:100];
//    title.text = @"猜大小娱乐场";
    
    sepLine.sd_layout
    .bottomEqualToView(fatherView)
    .heightIs(1)
    .leftSpaceToView(fatherView, 0)
    .rightSpaceToView(fatherView, 0)
    ;
    
    introduce.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(img, 15)
    .rightSpaceToView(fatherView, 50)
    .autoHeightRatio(0)
    ;
    [introduce setMaxNumberOfLinesToShow:2];
//    introduce.text = @"简介：猜大小娱乐场是当今比较流行的游戏，方 便人们的操作，娱乐与赚钱于一体.";
}

-(void)setModel:(CompanyDetailModel *)model
{
    _model = model;
    
    if ([model.companyName containsString:@"<font"]) {
        title.attributedText = [NSString analysisHtmlString:GetSaveString(model.companyName)];
        [title addTitleColorTheme];
        title.font = PFFontR(16);
    }else{
        title.text = GetSaveString(model.companyName);
    }
    
    @weakify(self);
    //点击详情
    [webUrl whenTap:^{
        @strongify(self);
        if (self.webPushBlock) {
            self.webPushBlock();
        }
    }];
    
//    introduce.text = GetSaveString(model.information);
    
    [img sd_setImageWithURL:UrlWithStr(GetSaveString(model.logo))];
}

@end
