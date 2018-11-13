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
    [self.contentView addSubview:imageV];
    imageV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(5, 10, 5, 10));
    
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    _model = model;
    imageV.image = model.image;
}

@end
