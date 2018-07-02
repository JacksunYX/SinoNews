//
//  MyFansTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyFansTableViewCell.h"

@implementation MyFansTableViewCell

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
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    
}

-(void)setModel:(MyFansModel *)model
{
    _model = model;
}


@end
