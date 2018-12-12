//
//  SelectPublishChannelCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/7.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "SelectPublishChannelCell.h"

NSString * _Nullable const SelectPublishChannelCellID = @"SelectPublishChannelCellID";

@interface SelectPublishChannelCell ()
{
    UILabel *title;
}
@end

@implementation SelectPublishChannelCell

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
        UIView *selectBackgroundView = [[UIView alloc]initWithFrame:self.frame];
        selectBackgroundView.backgroundColor = WhiteColor;
        [self setSelectedBackgroundView:selectBackgroundView];
    }
    return self;
}

//添加未选中时的背景
-(void)addBackgroundView
{
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.frame];
    backgroundView.backgroundColor = WhiteColor;
    UIImageView *line = [UIImageView new];
    [backgroundView addSubview:line];
    line.backgroundColor = HexColor(#e9e9e9);
    line.sd_layout
    .topEqualToView(backgroundView)
    .rightEqualToView(backgroundView)
    .bottomEqualToView(backgroundView)
    .widthIs(1)
    ;
    [self setBackgroundView:backgroundView];
}

//修改选中时的背景
-(void)addSelectedBackgroundView
{
    
    UIView *selectBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    selectBackgroundView.backgroundColor = WhiteColor;
    UIImageView *line = [UIImageView new];
    [selectBackgroundView addSubview:line];
    line.sd_layout
    .topEqualToView(selectBackgroundView)
    .rightEqualToView(selectBackgroundView)
    .bottomEqualToView(selectBackgroundView)
    .widthIs(8)
    ;
    line.image = UIImageNamed(@"selectChannel_arrow");
    [self setSelectedBackgroundView:selectBackgroundView];
}

-(void)setType:(NSInteger)type
{
    _type = type;
    if (type) {
        [self addBackgroundView];
        [self addSelectedBackgroundView];
    }
}

-(void)setUI
{
    self.backgroundColor = WhiteColor;
    title = [UILabel new];
    title.textColor = HexColor(#161A24);
    title.font = PFFontL(15);
    title.highlightedTextColor = HexColor(#1282ee);
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 1;
    
    [self.contentView addSubview:title];
    title.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 15)
    .heightIs(20)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:ScreenW * 0.3 - 20];
    
    [self setupAutoHeightWithBottomView:title bottomMargin:15];
}

-(void)setTitle:(NSString *)titleString
{
    title.text = titleString;
}



@end
