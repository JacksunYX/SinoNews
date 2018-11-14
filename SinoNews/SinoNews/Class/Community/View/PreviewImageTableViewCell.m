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
    UILabel *descripion;    //描述
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
    descripion = [UILabel new];
    
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
    .autoHeightRatio(0)
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
    imageV.image = model.image;
    CGFloat imageW = (ScreenW - 20);
    imageV.sd_layout
    .heightIs(imageW * model.imageH/model.imageW)
    ;
    [imageV updateLayout];
    CGFloat playW = 0;
    
    NSString *des = GetSaveString(model.imageDes);
    if (model.addtType == 3) {
        playW = 42;
        des = GetSaveString(model.videoDes);
    }
    playBtn.sd_layout
    .widthIs(playW)
    ;
    
    descripion.text = des;
}

@end
