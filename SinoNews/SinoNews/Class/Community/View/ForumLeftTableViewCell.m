//
//  ForumLeftTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/24.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumLeftTableViewCell.h"

NSString *const ForumLeftTableViewCellID = @"ForumLeftTableViewCell";

@interface ForumLeftTableViewCell ()
{
    UILabel *title;
}
@end

@implementation ForumLeftTableViewCell

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
        
        [self addSelectedBackgroundView];
    }
    return self;
}

//修改选中时的背景
-(void)addSelectedBackgroundView
{
    self.backgroundColor = BACKGROUND_COLOR;
    UIView *backgroundViews = [[UIView alloc]initWithFrame:self.frame];
    backgroundViews.backgroundColor = WhiteColor;
    UIView *line = [UIView new];
    line.backgroundColor = HexColor(#1282ee);
    [backgroundViews addSubview:line];
    line.sd_layout
    .leftEqualToView(backgroundViews)
    .centerYEqualToView(backgroundViews)
    .widthIs(4)
    .heightIs(20)
    ;
    
    [self setSelectedBackgroundView:backgroundViews];
}

-(void)setUI
{
    title = [UILabel new];
    title.textColor = BlackColor;
    title.font = PFFontL(14);
    title.highlightedTextColor = HexColor(#1282ee);
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 1;
    
    [self.contentView addSubview:title];
    title.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 15)
    .heightIs(20)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:ScreenH * 0.3 - 20];
    
    [self setupAutoHeightWithBottomView:title bottomMargin:15];
}

-(void)setTitle:(NSString *)titleString
{
    title.text = titleString;
}

@end
