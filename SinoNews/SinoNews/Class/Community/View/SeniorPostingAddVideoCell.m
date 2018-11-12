//
//  SeniorPostingAddVideoCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddVideoCell.h"

NSString * const SeniorPostingAddVideoCellID = @"SeniorPostingAddVideoCellID";

@interface SeniorPostingAddVideoCell ()
{
    UIImageView *selectVideo;
    UIButton *uploadStatus;
    FSTextView *videoDescript;
}
@end

@implementation SeniorPostingAddVideoCell

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
    selectVideo = [UIImageView new];
    UIImageView *videoIcon = [UIImageView new];
    uploadStatus = [UIButton new];
    videoDescript = [FSTextView textView];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 selectVideo,
                                 videoDescript,
                                 ]];
    selectVideo.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .widthIs(105)
    .heightEqualToWidth()
    ;
    selectVideo.backgroundColor = Arc4randomColor;
    
    videoDescript.sd_layout
    .topEqualToView(selectVideo)
    .leftSpaceToView(selectVideo, 10)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(selectVideo)
    ;
    videoDescript.textColor = HexColor(#161A24);
    videoDescript.font = PFFontR(15);
    videoDescript.placeholder = @"给视频配点文案～";
    videoDescript.placeholderColor = HexColor(#B9C3C7);
    videoDescript.userInteractionEnabled = NO;
    
    [selectVideo addSubview:videoIcon];
    videoIcon.sd_layout
    .centerXEqualToView(selectVideo)
    .centerYEqualToView(selectVideo)
    .widthIs(42)
    .heightEqualToWidth()
    ;
//    videoIcon.backgroundColor = kWhite(0.4);
//    videoIcon.sd_cornerRadius = @21;
    videoIcon.image = UIImageNamed(@"videoCover_icon");
    
    /*
    [selectVideo addSubview:uploadStatus];
    uploadStatus.sd_layout
    .bottomEqualToView(selectVideo)
    .leftEqualToView(selectVideo)
    .rightEqualToView(selectVideo)
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
    */
    [self setupAutoHeightWithBottomView:selectVideo bottomMargin:15];
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    selectVideo.image = model.image;
    videoDescript.text = GetSaveString(model.videoDes);
}

@end
