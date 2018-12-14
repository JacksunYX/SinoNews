//
//  RecommendThirdCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/11.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RecommendThirdCell.h"

@interface RecommendThirdCell ()
{
    UIView *topView;
    UILabel *title1;
    UIImageView *img1;
    UILabel *subTitle1;
    UIButton *isAttention1;
    
    UIView *centerView;
    UILabel *title2;
    UIImageView *img2;
    UILabel *subTitle2;
    UIButton *isAttention2;
    
    UIView *bottomView;
    UILabel *title3;
    UIImageView *img3;
    UILabel *subTitle3;
    UIButton *isAttention3;
}
@end

@implementation RecommendThirdCell

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
    [self addViews];
}

-(void)addViews
{
    topView = [UIView new];
//    topView.backgroundColor = WhiteColor;
    topView.tag = 10010;
    UITapGestureRecognizer *topTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    topTap.numberOfTapsRequired = 1;
    [topView addGestureRecognizer:topTap];
    
    centerView = [UIView new];
//    centerView.backgroundColor = WhiteColor;
    centerView.tag = 10010 + 1;
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    centerTap.numberOfTapsRequired = 1;
    [centerView addGestureRecognizer:centerTap];
    
    bottomView = [UIView new];
//    bottomView.backgroundColor = WhiteColor;
    bottomView.tag = 10010 + 2;
    UITapGestureRecognizer *bottomTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    bottomTap.numberOfTapsRequired = 1;
    [bottomView addGestureRecognizer:bottomTap];
    
    [self.contentView sd_addSubviews:@[
                                       topView,
                                       centerView,
                                       bottomView,
                                       
                                       ]];
    topView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(68)
    ;
    
    centerView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 68)
    .heightIs(68)
    ;
    
    bottomView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .heightIs(68)
    ;
    
    [self addTopView];
    [self addCenterView];
    [self addBottomView];
}

-(void)addTopView
{
    
    img1 = [UIImageView new];
    img1.userInteractionEnabled = YES;
    img1.contentMode = 2;
    img1.layer.masksToBounds = YES;
    
    isAttention1 = [UIButton new];
    isAttention1.titleLabel.font = PFFontL(14);
    isAttention1.tag = 10086;
    [isAttention1 addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    title1 = [UILabel new];
    title1.font = PFFontL(16);
    title1.lee_theme.LeeConfigTextColor(@"titleColor");
    
    subTitle1 = [UILabel new];
    subTitle1.font = PFFontL(12);
    subTitle1.textColor = HexColor(#888888);
    
    [topView sd_addSubviews:@[
//                              img1,
                              isAttention1,
                              title1,
                              subTitle1,
                              
                              ]];
    
//    img1.sd_layout
//    .leftSpaceToView(topView, 10)
//    .topSpaceToView(topView, 10)
//    .widthIs(48)
//    .heightEqualToWidth()
//    ;
//    [img1 setSd_cornerRadius:@24];
//    img1.backgroundColor = Arc4randomColor;
    
    isAttention1.sd_layout
    .rightSpaceToView(topView, 10)
    .centerYEqualToView(topView)
    .widthIs(50)
    .heightIs(22)
    ;
    [isAttention1 setSd_cornerRadius:@2];
    [isAttention1 addBakcgroundColorTheme];
    [isAttention1 setTitle:@"关注" forState:UIControlStateNormal];
    [isAttention1 setTitle:@"已关注" forState:UIControlStateSelected];
    
    [isAttention1 setTitleColor:HexColor(#1282EE) forState:UIControlStateNormal];
    [isAttention1 setTitleColor:HexColor(#989898) forState:UIControlStateSelected];
    
    isAttention1.layer.borderColor = HexColor(#1282EE).CGColor;
    isAttention1.layer.borderWidth = 1;
    isAttention1.layer.cornerRadius = 2;
    
    title1.sd_layout
    .leftSpaceToView(topView, 10)
    .topSpaceToView(topView, 21)
    .rightSpaceToView(isAttention1, 10)
//    .autoHeightRatio(0)
    .heightIs(16)
    ;
//    [title1 setMaxNumberOfLinesToShow:1];
    
    subTitle1.sd_layout
    .leftEqualToView(title1)
    .topSpaceToView(title1, 5)
    .rightSpaceToView(isAttention1, 10)
    .autoHeightRatio(0)
    ;
    [subTitle1 setMaxNumberOfLinesToShow:1];
    
    
}

-(void)addCenterView
{
    UIView *line1 = [UIView new];
    line1.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }else{
            [(UIView *)item setBackgroundColor:CutLineColor];
        }
    });
    
    img2 = [UIImageView new];
    img2.userInteractionEnabled = YES;
    img2.contentMode = 2;
    img2.layer.masksToBounds = YES;
    
    isAttention2 = [UIButton new];
    isAttention2.titleLabel.font = PFFontL(14);
    isAttention2.tag = 10086 + 1;
    [isAttention2 addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    title2 = [UILabel new];
    title2.font = PFFontL(16);
    title2.lee_theme.LeeConfigTextColor(@"titleColor");
    
    subTitle2 = [UILabel new];
    subTitle2.font = PFFontL(12);
    subTitle2.textColor = HexColor(#888888);
    
    [centerView sd_addSubviews:@[
                                 line1,
//                                 img2,
                                 isAttention2,
                                 title2,
                                 subTitle2,
                                 
                                 ]];
    
    line1.sd_layout
    .leftSpaceToView(centerView, 10)
    .topEqualToView(centerView)
    .rightSpaceToView(centerView, 10)
    .heightIs(1)
    ;
    
//    img2.sd_layout
//    .leftSpaceToView(centerView, 10)
//    .topSpaceToView(line1, 10)
//    .widthIs(48)
//    .heightEqualToWidth()
//    ;
//    [img2 setSd_cornerRadius:@24];
//    img2.backgroundColor = Arc4randomColor;
    
    isAttention2.sd_layout
    .rightSpaceToView(centerView, 10)
    .centerYEqualToView(centerView)
    .widthIs(50)
    .heightIs(22)
    ;
    [isAttention2 setSd_cornerRadius:@2];
    [isAttention2 addBakcgroundColorTheme];
    [isAttention2 setTitle:@"关注" forState:UIControlStateNormal];
    [isAttention2 setTitle:@"已关注" forState:UIControlStateSelected];
    
    [isAttention2 setTitleColor:HexColor(#1282EE) forState:UIControlStateNormal];
    [isAttention2 setTitleColor:HexColor(#989898) forState:UIControlStateSelected];
    
    isAttention2.layer.borderColor = HexColor(#1282EE).CGColor;
    isAttention2.layer.borderWidth = 1;
    isAttention2.layer.cornerRadius = 2;
    
    title2.sd_layout
    .leftSpaceToView(centerView, 10)
    .topSpaceToView(line1, 21)
    .rightSpaceToView(isAttention2, 10)
//    .autoHeightRatio(0)
    .heightIs(16)
    ;
//    [title2 setMaxNumberOfLinesToShow:1];
    
    subTitle2.sd_layout
    .leftEqualToView(title2)
    .topSpaceToView(title2, 5)
    .rightSpaceToView(isAttention2, 10)
    .autoHeightRatio(0)
    ;
    [subTitle2 setMaxNumberOfLinesToShow:1];
}

-(void)addBottomView
{
    UIView *line2 = [UIView new];
    line2.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }else{
            [(UIView *)item setBackgroundColor:CutLineColor];
        }
    });
    
    img3 = [UIImageView new];
    img3.userInteractionEnabled = YES;
    img3.contentMode = 2;
    img3.layer.masksToBounds = YES;
    
    isAttention3 = [UIButton new];
    isAttention3.titleLabel.font = PFFontL(14);
    isAttention3.tag = 10086 + 2;
    [isAttention3 addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    title3 = [UILabel new];
    title3.font = PFFontL(16);
    title3.lee_theme.LeeConfigTextColor(@"titleColor");
    
    subTitle3 = [UILabel new];
    subTitle3.font = PFFontL(12);
    subTitle3.textColor = HexColor(#888888);
    
    [bottomView sd_addSubviews:@[
                                 line2,
//                                 img3,
                                 isAttention3,
                                 title3,
                                 subTitle3,
                                 
                                 ]];
    
    line2.sd_layout
    .leftSpaceToView(bottomView, 10)
    .topEqualToView(bottomView)
    .rightSpaceToView(bottomView, 10)
    .heightIs(1)
    ;
    
//    img3.sd_layout
//    .leftSpaceToView(bottomView, 10)
//    .topSpaceToView(line2, 10)
//    .widthIs(48)
//    .heightEqualToWidth()
//    ;
//    [img3 setSd_cornerRadius:@24];
//    img3.backgroundColor = Arc4randomColor;
    
    isAttention3.sd_layout
    .rightSpaceToView(bottomView, 10)
    .centerYEqualToView(bottomView)
    .widthIs(50)
    .heightIs(22)
    ;
    [isAttention3 setSd_cornerRadius:@2];
    [isAttention3 addBakcgroundColorTheme];
    [isAttention3 setTitle:@"关注" forState:UIControlStateNormal];
    [isAttention3 setTitle:@"已关注" forState:UIControlStateSelected];
    
    [isAttention3 setTitleColor:HexColor(#1282EE) forState:UIControlStateNormal];
    [isAttention3 setTitleColor:HexColor(#989898) forState:UIControlStateSelected];
    
    isAttention3.layer.borderColor = HexColor(#1282EE).CGColor;
    isAttention3.layer.borderWidth = 1;
    isAttention3.layer.cornerRadius = 2;
    
    title3.sd_layout
    .leftSpaceToView(bottomView, 10)
    .topSpaceToView(line2, 21)
    .rightSpaceToView(isAttention3, 10)
//    .autoHeightRatio(0)
    .heightIs(16)
    ;
//    [title3 setMaxNumberOfLinesToShow:1];
    
    subTitle3.sd_layout
    .leftEqualToView(title3)
    .topSpaceToView(title3, 5)
    .rightSpaceToView(isAttention3, 10)
    .autoHeightRatio(0)
    ;
    [subTitle3 setMaxNumberOfLinesToShow:1];
}


-(void)setModel:(AttentionRecommendModel *)model
{
    _model = model;
    
//    img1.image = UIImageNamed(GetSaveString(model.img));
    title1.text = GetSaveString(model.title);
    subTitle1.text = GetSaveString(model.subTitle);
    
    if (model.isAttention) {
        isAttention1.selected = YES;
        isAttention1.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention1.selected = NO;
        isAttention1.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
//    img2.image = UIImageNamed(GetSaveString(model.img));
    title2.text = GetSaveString(model.title);
    subTitle2.text = GetSaveString(model.subTitle);
    
    if (model.isAttention) {
        isAttention2.selected = YES;
        isAttention2.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention2.selected = NO;
        isAttention2.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
//    img3.image = UIImageNamed(GetSaveString(model.img));
    title3.text = GetSaveString(model.title);
    subTitle3.text = GetSaveString(model.subTitle);
    
    if (model.isAttention) {
        isAttention3.selected = YES;
        isAttention3.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention3.selected = NO;
        isAttention3.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
}

- (void)setModelArr:(NSArray *)modelArr
{
    _modelArr = modelArr;
    
    RecommendChannelModel *model1 = modelArr[0];
    RecommendChannelModel *model2 = modelArr[1];
    RecommendChannelModel *model3 = modelArr[2];
//    img1.image = UIImageNamed(GetSaveString(model1.img));
    title1.text = GetSaveString(model1.name);
//    subTitle1.text = GetSaveString(model1.subTitle);
    
    if (model1.isAttention) {
        isAttention1.selected = YES;
        isAttention1.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention1.selected = NO;
        isAttention1.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
//    img2.image = UIImageNamed(GetSaveString(model2.img));
    title2.text = GetSaveString(model2.name);
//    subTitle2.text = GetSaveString(model2.subTitle);
    
    if (model2.isAttention) {
        isAttention2.selected = YES;
        isAttention2.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention2.selected = NO;
        isAttention2.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
//    img3.image = UIImageNamed(GetSaveString(model3.img));
    title3.text = GetSaveString(model3.name);
//    subTitle3.text = GetSaveString(model3.subTitle);
    
    if (model3.isAttention) {
        isAttention3.selected = YES;
        isAttention3.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention3.selected = NO;
        isAttention3.layer.borderColor = HexColor(#1282EE).CGColor;
    }
}

-(void)attentionAction:(UIButton *)btn
{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        btn.layer.borderColor = HexColor(#E3E3E3).CGColor;
//    }else{
//        btn.layer.borderColor = HexColor(#1282EE).CGColor;
//    }
    if (self.attentionIndex) {
        self.attentionIndex(self.tag, btn.tag - 10086);
    }
}

-(void)tapGesture:(UITapGestureRecognizer *)tap
{
    UIView *tapView = tap.view;
    //    GGLog(@"点击了第%ld个cell",tapView.tag - 10010);
    if (self.selectedIndex) {
        self.selectedIndex(self.tag, tapView.tag - 10010);
    }
    
}


@end
