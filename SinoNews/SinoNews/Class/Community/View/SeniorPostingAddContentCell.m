//
//  SeniorPostingAddContentCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddContentCell.h"

NSString * const SeniorPostingAddContentCellID = @"SeniorPostingAddContentCellID";
@interface SeniorPostingAddContentCell ()
{
    FSTextView *content;
}
@end

@implementation SeniorPostingAddContentCell

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
    content = [FSTextView textView];
    [self.contentView addSubview:content];
    content.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .heightIs(200)
    ;
    content.textColor = HexColor(#161A24);
    content.font = PFFontR(15);
    content.editable = NO;
    
    [self setupAutoHeightWithBottomView:content bottomMargin:20];
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    content.text = GetSaveString(model.content);
}

@end
