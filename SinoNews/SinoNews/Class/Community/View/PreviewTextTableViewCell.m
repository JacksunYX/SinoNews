//
//  PreviewTextTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PreviewTextTableViewCell.h"


NSString * const PreviewTextTableViewCellID = @"PreviewTextTableViewCellID";

@interface PreviewTextTableViewCell ()
{
    UILabel *textLabel;
}
@end

@implementation PreviewTextTableViewCell

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
    textLabel = [UILabel new];
    [self.contentView addSubview:textLabel];
    textLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
    
    textLabel.textColor = BlackColor;
    
    [self setupAutoHeightWithBottomView:textLabel bottomMargin:10];
    
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    if (model.addtType == 0) {
        textLabel.font = PFFontR(20);
        textLabel.text = GetSaveString(model.title);
    }else if (model.addtType == 1){
        textLabel.font = PFFontR(15);
        textLabel.text = GetSaveString(model.content);
    }
    [textLabel updateLayout];
}

@end
