//
//  VotePostingTableViewCell2.m
//  SinoNews
//
//  Created by Michael on 2018/11/9.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "VotePostingTableViewCell2.h"

NSString * const VotePostingTableViewCell2ID = @"VotePostingTableViewCell2ID";

@interface VotePostingTableViewCell2 ()
{
    UILabel *leftTitle;
    UISwitch *rightSwitch;
    UIImageView *rightArrow;
    UILabel *rightTitle;
}
@end

@implementation VotePostingTableViewCell2

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
    leftTitle = [UILabel new];
    rightSwitch = [UISwitch new];
    rightArrow = [UIImageView new];
    rightTitle = [UILabel new];
    
    leftTitle.font = PFFontL(14);
    rightTitle.font = PFFontL(13);
    rightTitle.textColor = HexColor(#ACB5B9);
    
    UIView *fatherView = self.contentView;
    
    [fatherView sd_addSubviews:@[
                                 leftTitle,
                                 rightSwitch,
                                 rightArrow,
                                 rightTitle,
                                 
                                 ]];
    leftTitle.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .heightIs(16)
    ;
    [leftTitle setSingleLineAutoResizeWithMaxWidth:100];
    
    rightSwitch.sd_layout
    .rightSpaceToView(fatherView, 16)
    .centerYEqualToView(fatherView)
    .widthIs(45)
    .heightIs(25)
    ;
    rightSwitch.hidden = YES;
    
    rightArrow.sd_layout
    .rightSpaceToView(fatherView, 16)
    .centerYEqualToView(fatherView)
    .widthIs(7)
    .heightIs(10)
    ;
    rightArrow.image = UIImageNamed(@"voteArrow_icon");
    
    rightTitle.sd_layout
    .rightSpaceToView(rightArrow, 16)
    .centerYEqualToView(fatherView)
    .heightIs(14)
    ;
    [rightTitle setSingleLineAutoResizeWithMaxWidth:100];
    
    [rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(UISwitch *)sender
{
    if (self.switchBlock) {
        self.switchBlock(sender.on);
    }
}

-(void)setType:(NSInteger)type
{
    _type = type;
    
    rightSwitch.hidden = !type;
    rightArrow.hidden = type;
    rightTitle.hidden = type;
}

-(void)setLeftTitle:(NSString *)title
{
    leftTitle.text = GetSaveString(title);
}

-(void)setRightTitle:(NSString *)title
{
    rightTitle.text = GetSaveString(title);
}

-(void)setRightSwitchOn:(BOOL)on
{
    rightSwitch.on = on;
}

@end
