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
    YXLabel *textLabel;
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
    
    textLabel = [YXLabel new];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentJustified;
    
    [self.contentView addSubview:textLabel];
    textLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0)
    ;
    
    textLabel.textColor = BlackColor;
    
    [self setupAutoHeightWithBottomView:textLabel bottomMargin:10];
    
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    NSString *string;
    if (model.addType == 0) {
        textLabel.font = PFFontR(20);
        string = [NSString stringWithFormat:@"%@、%@",[NSString getChineseWithNum:model.sectionNum],GetSaveString(model.title)];
    }else if (model.addType == 1){
        textLabel.font = PFFontR(16);
        string = GetSaveString(model.content);
    }
    textLabel.text = string;
    CGFloat height = [textLabel getLabelWithLineSpace:3 width:ScreenW - 20];
    
    textLabel.sd_layout
    .heightIs(height)
    ;
    [textLabel updateLayout];
}


@end
