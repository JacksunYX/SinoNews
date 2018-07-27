//
//  RecommendFirstCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RecommendFirstCell.h"

@interface RecommendFirstCell ()
{
    UILabel *title;
    UILabel *fansNum;
    UILabel *subTitle;
    UIButton *isAttention;
}
@end

@implementation RecommendFirstCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    self.layer.cornerRadius = 9.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
//    self.layer.borderColor = HexColor(#E3E3E3).CGColor;
    
    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UICollectionViewCell *)item setBackgroundColor:value];
        if (UserGetBool(@"NightMode")) {
            [[(UICollectionViewCell *)item layer] setBorderColor:ClearColor.CGColor];
            [(UICollectionViewCell *)item setBackgroundColor:HexColor(#292D30)];
        }else{
            [[(UICollectionViewCell *)item layer] setBorderColor:CutLineColor.CGColor];
        }
    });
//    [self cornerWithRadius:9];
    
    title = [UILabel new];
    title.font = PFFontL(16);
    [title addTitleColorTheme];
    
    fansNum = [UILabel new];
    fansNum.font = PFFontL(12);
    fansNum.textColor = HexColor(#888888);
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(12);
    [subTitle addTitleColorTheme];
    
    isAttention = [UIButton new];
    isAttention.titleLabel.font = PFFontL(14);
    [isAttention addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView sd_addSubviews:@[
                                       isAttention,
                                       title,
                                       fansNum,
                                       subTitle,
                                       ]];
    isAttention.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 24)
    .widthIs(50)
    .heightIs(22)
    ;
    [isAttention setSd_cornerRadius:@2];
    [isAttention addBakcgroundColorTheme];
    [isAttention setTitle:@"关注" forState:UIControlStateNormal];
    [isAttention setTitle:@"已关注" forState:UIControlStateSelected];
    
    [isAttention setTitleColor:HexColor(#1282EE) forState:UIControlStateNormal];
    [isAttention setTitleColor:HexColor(#989898) forState:UIControlStateSelected];
    
    isAttention.layer.borderColor = HexColor(#1282EE).CGColor;
    isAttention.layer.borderWidth = 1;
    isAttention.layer.cornerRadius = 2;
    
    title.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(isAttention, 10)
//    .autoHeightRatio(0)
    .heightIs(16)
    ;
//    [title setMaxNumberOfLinesToShow:2];
    
    fansNum.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(title, 5)
    .rightEqualToView(title)
    .autoHeightRatio(0)
    ;
    [fansNum setMaxNumberOfLinesToShow:1];
    
    subTitle.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(fansNum, 15)
    .rightSpaceToView(self.contentView, 30)
    .autoHeightRatio(0)
    ;
    [subTitle setMaxNumberOfLinesToShow:3];
}

-(void)setModel:(AttentionRecommendModel *)model
{
    _model = model;
    
    title.text = [NSString stringWithFormat:@"# %@ #",GetSaveString(model.title)];
    fansNum.text = [NSString stringWithFormat:@"%ld 粉丝",model.fansNum];
    subTitle.text = GetSaveString(model.subTitle);
    
    if (model.isAttention) {
        isAttention.selected = YES;
        isAttention.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention.selected = NO;
        isAttention.layer.borderColor = HexColor(#1282EE).CGColor;
    }
}

-(void)attentionAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        isAttention.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
    if (self.attentionIndex) {
        self.attentionIndex(self.tag);
    }
}








@end
