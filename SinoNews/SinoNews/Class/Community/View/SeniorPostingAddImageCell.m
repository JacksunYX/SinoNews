//
//  SeniorPostingAddImageCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddImageCell.h"

NSString * const SeniorPostingAddImageCellID = @"SeniorPostingAddImageCellID";
@interface SeniorPostingAddImageCell ()
{
    UIImageView *selectImage;
    UIButton *uploadStatus;
    FSTextView *imageDescript;
}
@end

@implementation SeniorPostingAddImageCell

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
    selectImage = [UIImageView new];
    uploadStatus = [UIButton new];
    imageDescript = [FSTextView textView];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 selectImage,
                                 imageDescript,
                                 ]];
    selectImage.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .widthIs(105)
    .heightEqualToWidth()
    ;
    selectImage.backgroundColor = Arc4randomColor;
    
    imageDescript.sd_layout
    .topEqualToView(selectImage)
    .leftSpaceToView(selectImage, 10)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(selectImage)
    ;
    imageDescript.textColor = HexColor(#161A24);
    imageDescript.font = PFFontR(15);
    imageDescript.placeholder = @"给图片配点文案～";
    imageDescript.placeholderColor = HexColor(#B9C3C7);
    imageDescript.userInteractionEnabled = NO;
    
    [selectImage addSubview:uploadStatus];
    uploadStatus.sd_layout
    .bottomEqualToView(selectImage)
    .leftEqualToView(selectImage)
    .rightEqualToView(selectImage)
    .heightIs(20)
    ;
    [uploadStatus setBtnFont:PFFontL(12)];
    [uploadStatus setNormalTitleColor:WhiteColor];
    [uploadStatus setSelectedTitleColor:WhiteColor];
    [uploadStatus setNormalTitle:@"正在上传"];
    [uploadStatus setSelectedTitle:@"上传成功"];
    [uploadStatus setNormalImage:nil];
    [uploadStatus setSelectedImage:UIImageNamed(@"uploadSuccess_icon")];
    [uploadStatus setBackgroundImage:[UIImage imageWithColor:HexColorAlpha(#000000, 0.36)] forState:UIControlStateNormal];
    [uploadStatus setBackgroundImage:[UIImage imageWithColor:HexColor(#1282EE)] forState:UIControlStateSelected];
    
    [self setupAutoHeightWithBottomView:selectImage bottomMargin:15];
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    selectImage.image = model.image;
    imageDescript.text = GetSaveString(model.imageDes);
}

@end
