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
    UILabel *numLabel;
    UILabel *titleLabel;
    UILabel *pushTime;
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
    numLabel = [UILabel new];
    titleLabel = [UILabel new];
    pushTime = [UILabel new];
    operationLabel = [UILabel new];
    
//    numLabel.backgroundColor = RedColor;
//    titleLabel.backgroundColor = RedColor;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 numLabel,
                                 titleLabel,
                                 pushTime,
                                 operationLabel,
                                 ]];
    numLabel.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(20)
    .heightIs(16)
    ;
    numLabel.font = PFFontM(16);
    numLabel.textColor = HexColor(#161A24);
    numLabel.text = @"1";
    
    titleLabel.sd_layout
    .topSpaceToView(fatherView, 7)
    .leftSpaceToView(numLabel, 5)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
    titleLabel.font = PFFontL(15);
    titleLabel.textColor = HexColor(#161A24);
    titleLabel. text = @"尤为值得关注的是，高新技术投资是亮点。京东 金融副总裁、首席经济学家，尤为值得关注的是，高新技术投资是亮点。京东 金融副总裁、首席经济学家";
    
    operationLabel.sd_layout
    .topSpaceToView(titleLabel, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(10)
    ;
    [operationLabel setSingleLineAutoResizeWithMaxWidth:100];
    operationLabel.font = PFFontL(11);
    operationLabel.textColor = HexColor(#ABB2C3);
    operationLabel. text = @"30 阅读";
    
    pushTime.sd_layout
    .centerYEqualToView(operationLabel)
    .leftEqualToView(titleLabel)
    .heightIs(10)
    ;
    [pushTime setSingleLineAutoResizeWithMaxWidth:100];
    pushTime.font = PFFontL(11);
    pushTime.textColor = HexColor(#898989);
    pushTime. text = @"1小时前";
    
    [self setupAutoHeightWithBottomView:pushTime bottomMargin:12];
}

-(void)setModel:(HotContentModel *)model
{
    _model = model;
}


@end
