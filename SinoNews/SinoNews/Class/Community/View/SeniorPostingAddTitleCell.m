//
//  SeniorPostingAddTitleCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/12.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SeniorPostingAddTitleCell.h"

NSString * const SeniorPostingAddTitleCellID = @"SeniorPostingAddTitleCellID";
@interface SeniorPostingAddTitleCell ()
{
    UILabel *title;
}
@end

@implementation SeniorPostingAddTitleCell

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
    title = [UILabel new];
    [self.contentView addSubview:title];
    title.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20)
    ;
    title.textColor = HexColor(#161A24);
    title.font = PFFontR(20);
    title.userInteractionEnabled = NO;
    
    [self setupAutoHeightWithBottomView:title bottomMargin:20];
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    title.text = GetSaveString(model.title);
}

@end
