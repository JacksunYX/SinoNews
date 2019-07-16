//
//  HotContentTableViewCell.m
//  SinoNews
//
//  Created by 玉潇  孙 on 2019/6/26.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "HotContentTableViewCell.h"

NSString *const HotContentTableViewCellID = @"HotContentTableViewCellID";

@interface HotContentTableViewCell ()
{
    UIImageView *rightImg;
    UILabel *numLabel;
    UILabel *titleLabel;
    UILabel *usernameLabel;
    UILabel *operationLabel;
}
@end

@implementation HotContentTableViewCell

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
    rightImg = [UIImageView new];
    rightImg.contentMode = 2;
    numLabel = [UILabel new];
    titleLabel = [UILabel new];
    usernameLabel = [UILabel new];
    operationLabel = [UILabel new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 rightImg,
                                 numLabel,
                                 titleLabel,
                                 operationLabel,
                                 usernameLabel,
                                 ]];
    //布局
    rightImg.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(kScaelW(118))
    .heightIs(kScaelW(118)*82/118)
    //    .widthIs(kScaelW(105))
    //    .heightEqualToWidth()
    ;
    [rightImg setSd_cornerRadius:@4];
    
    numLabel.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(20)
    .heightIs(16)
    ;
    numLabel.font = PFFontM(16);
    numLabel.textColor = HexColor(#161A24);
    
    titleLabel.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(numLabel, 5)
    .rightSpaceToView(rightImg, 10)
    .autoHeightRatio(0)
    ;
    titleLabel.font = PFFontL(15);
    titleLabel.textColor = HexColor(#161A24);
    
    operationLabel.sd_layout
    .bottomEqualToView(rightImg)
    .rightSpaceToView(rightImg, 10)
    .heightIs(10)
    ;
    [operationLabel setSingleLineAutoResizeWithMaxWidth:100];
    operationLabel.font = PFFontL(11);
    operationLabel.textColor = HexColor(#ABB2C3);
    
    usernameLabel.sd_layout
    .centerYEqualToView(operationLabel)
    .leftEqualToView(titleLabel)
    .heightIs(10)
    ;
    [usernameLabel setSingleLineAutoResizeWithMaxWidth:100];
    usernameLabel.font = PFFontL(11);
    usernameLabel.textColor = HexColor(#898989);
    
    [self setupAutoHeightWithBottomView:rightImg bottomMargin:10];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    NSInteger num = [model[@"num"] integerValue];
    numLabel.text = [NSString stringWithFormat:@"%ld",num];
   titleLabel.text = model[@"title"] ;
    
    usernameLabel.text = model[@"username"];
    NSInteger type = [model[@"type"] integerValue];
    NSInteger viewCount = [model[@"viewCount"] integerValue];
    NSInteger praiseCount = [model[@"praiseCount"] integerValue];
    NSString *str = @"";
    NSString *spellStr;
    if (type == 1) {
        str = @"点赞";
        spellStr = [NSString stringWithFormat:@"%ld %@",praiseCount ,str];
    }else{
        str = @"阅读";
        spellStr = [NSString stringWithFormat:@"%ld %@",viewCount ,str];
    }
    
    operationLabel.text = spellStr;
    
    NSString *imgUrl = model[@"image"];
    [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(imgUrl)) placeholderImage:nil];
}


@end
