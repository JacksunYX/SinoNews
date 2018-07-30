//
//  CateChismTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CateChismTableViewCell.h"
@interface CateChismTableViewCell ()
{
    UIImageView *avatar;
    UILabel *username;
    UIButton *praise;   //点赞
    UILabel *content;   //内容
    UIImageView *imgL;
    UIImageView *imgC;
    UIImageView *imgR;
    UILabel *bottomLabel;
    UILabel *typeLabel;
}
@end

@implementation CateChismTableViewCell

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
    
    avatar = [UIImageView new];
    avatar.backgroundColor = Arc4randomColor;
    
    username = [UILabel new];
    username.font = PFFontR(12);
    username.lee_theme.LeeConfigTextColor(@"titleColor");
    
    praise = [UIButton new];
    [praise setNormalTitleColor:HexColor(#929697)];
    praise.titleLabel.font = PFFontL(12);
    
    content = [UILabel new];
//    content.textColor = HexColor(#323232);
    [content addContentColorTheme];
    content.font = PFFontL(15);
    
    imgL = [UIImageView new];
    imgL.userInteractionEnabled = YES;
    imgL.backgroundColor = Arc4randomColor;
    imgC = [UIImageView new];
    imgC.userInteractionEnabled = YES;
    imgC.backgroundColor = Arc4randomColor;
    imgR = [UIImageView new];
    imgR.userInteractionEnabled = YES;
    imgR.backgroundColor = Arc4randomColor;
    
    [self.contentView sd_addSubviews:@[
                                       avatar,
                                       username,
                                       content,
                                       praise,
                                       
                                       imgL,
                                       imgC,
                                       imgR,
                                       
                                       ]];
    avatar.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(28)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@14];
    
    username.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 10)
    .heightIs(12)
    ;
    [username setSingleLineAutoResizeWithMaxWidth:80];
    
    praise.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
    //    praise.backgroundColor = Arc4randomColor;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    [praise setNormalImage:UIImageNamed(@"company_unPraise")];
    [praise setSelectedImage:UIImageNamed(@"company_praised")];
    
    content.sd_layout
    .leftEqualToView(avatar)
    .topSpaceToView(avatar, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
    //最多显示5行
    [content setMaxNumberOfLinesToShow:5];
    
    [self setupAutoHeightWithBottomView:imgL bottomMargin:10];
}

-(void)setModel:(AnswerModel *)model
{
    _model = model;
    
    [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(model.avatar))];
    username.text = GetSaveString(model.username);
    content.text = GetSaveString(model.html);
    
    praise.selected = model.hasPraise;
    
    NSString *count = @"";
    if (model.favorCount) {
        count = [NSString stringWithFormat:@"%ld",model.favorCount];
    }
    if (praise.selected) {
        [praise setSelectedTitle:count];
    }else{
        [praise setNormalTitle:count];
    }
    
    @weakify(self)
    [[praise rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self addanimation];
        if (self.praiseBlock) {
            self.praiseBlock();
        }
    }];
    
    [avatar whenTap:^{
       @strongify(self)
        if (self.avatarBlock) {
            self.avatarBlock();
        }
    }];
    
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lrMargin = 10;  //左右间距
    CGFloat imgMargin = 5;  //图片间距
    CGFloat tbMargin = 0;  //上下间距
    CGFloat imgWL = 0;
    CGFloat imgWC = 0;
    CGFloat imgWR = 0;
    if (self.model.images.count != 0) {
        tbMargin = 10;
    }
    if (self.model.images.count == 1) {
        imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
        [imgL sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[0]))];
    }else if (self.model.images.count == 2){
        imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
        imgWC = imgWL;
        [imgL sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[0]))];
        [imgC sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[1]))];
    }else if (self.model.images.count >=3){
        imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
        imgWC = imgWL;
        imgWR = imgWL;
        [imgL sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[0]))];
        [imgC sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[1]))];
        [imgR sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.images[2]))];
    }
    
    imgL.sd_layout
    .topSpaceToView(content, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgWL)
    .heightEqualToWidth()
    ;
    [imgL setSd_cornerRadius:@4];
    
    imgC.sd_layout
    .topEqualToView(imgL)
    .leftSpaceToView(imgL, imgMargin)
    .widthIs(imgWC)
    .heightEqualToWidth()
    ;
    [imgC setSd_cornerRadius:@4];
    
    imgR.sd_layout
    .topEqualToView(imgC)
    .leftSpaceToView(imgC, imgMargin)
    .widthIs(imgWR)
    .heightEqualToWidth()
    ;
    [imgR setSd_cornerRadius:@4];
    
}

//点赞的动画
- (void)addanimation
{
    //放大动画
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.5),@(1.0),@(1.5),@(1.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [praise.layer addAnimation:k forKey:@"SHOW"];
}

@end
