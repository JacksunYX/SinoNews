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
    
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
}

@end