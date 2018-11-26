//
//  PreviewImageTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PreviewImageTableViewCell.h"


NSString * const PreviewImageTableViewCellID = @"PreviewImageTableViewCellID";

@interface PreviewImageTableViewCell ()
{
    UIImageView *imageV;
    YXLabel *descripion;    //描述
    UIButton *playBtn;
}
@end

@implementation PreviewImageTableViewCell

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
    imageV = [UIImageView new];
    descripion = [YXLabel new];
    descripion.numberOfLines = 0;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 imageV,
                                 descripion,
                                 ]];
    imageV.sd_layout
    .topEqualToView(fatherView)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(0)
    ;
    
    descripion.sd_layout
    .topSpaceToView(imageV, 5)
    .leftEqualToView(imageV)
    .rightEqualToView(imageV)
    .heightIs(1)
    ;
    descripion.font = PFFontL(14);
    descripion.textColor = HexColor(#B9C3C7);
    
    playBtn = [UIButton new];
    [imageV addSubview:playBtn];
    playBtn.sd_layout
    .centerXEqualToView(imageV)
    .centerYEqualToView(imageV)
    .widthIs(0)
    .heightEqualToWidth()
    ;
    
    [playBtn setNormalImage:UIImageNamed(@"videoCover_icon")];
    
    [self setupAutoHeightWithBottomView:descripion bottomMargin:10];
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    if (model.imageData) {
        imageV.image = model.imageData.toImage;
    }else{
        [imageV sd_setImageWithURL:UrlWithStr(model.imageUrl)];
    }
    
    CGFloat imageW = (ScreenW - 20);
    imageV.sd_layout
    .heightIs(imageW * model.imageH/model.imageW)
    ;
    [imageV updateLayout];
    CGFloat playW = 0;
    
    NSString *des = GetSaveString(model.imageDes);
    if (model.addType == 3) {
        playW = 42;
        des = GetSaveString(model.videoDes);
    }
    playBtn.sd_layout
    .widthIs(playW)
    ;
    
    descripion.text = des;
    CGFloat height = [descripion getLabelWithLineSpace:3 width:ScreenW - 20];
    descripion.sd_layout
    .heightIs(height)
    ;
    [descripion updateLayout];
}

@end
