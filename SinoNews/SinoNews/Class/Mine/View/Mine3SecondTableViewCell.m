//
//  Mine3SecondTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/29.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "Mine3SecondTableViewCell.h"

NSString *const Mine3SecondTableViewCellID = @"Mine3SecondTableViewCellID";

@interface Mine3SecondTableViewCell ()
{
    UIImageView *icon;
    UILabel *title;
    UILabel *subTitle;
}
@end

@implementation Mine3SecondTableViewCell

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
    icon = [UIImageView new];
    icon.contentMode = 4;
    title = [UILabel new];
    title.font = PFFontL(14);
    [title addContentColorTheme];
    
    UIImageView *rightIcon = [UIImageView new];
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(12);
    
    UIView *line = [UIView new];
    [line addCutLineColor];
    
    UIView *fatherView = self.contentView;
    
    [fatherView sd_addSubviews:@[
                                 icon,
                                 title,
                                 rightIcon,
                                 subTitle,
                                 line,
                                 ]];
    icon.sd_layout
    .leftSpaceToView(fatherView, 30)
    .centerYEqualToView(fatherView)
    .widthIs(20)
    .heightEqualToWidth()
    ;
    
    title.sd_layout
    .leftSpaceToView(icon, 13)
    .centerYEqualToView(fatherView)
    .heightIs(16)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:50];
    
    rightIcon.sd_layout
    .rightSpaceToView(fatherView, 37)
    .centerYEqualToView(fatherView)
    .widthIs(10)
    .heightIs(15)
    ;
    rightIcon.image = UIImageNamed(@"big_ arrow");
    
    subTitle.sd_layout
    .rightSpaceToView(rightIcon, 16)
    .centerYEqualToView(fatherView)
    .heightIs(16)
    ;
    [subTitle setSingleLineAutoResizeWithMaxWidth:200];
    
    line.sd_layout
    .leftSpaceToView(icon, 8)
    .rightSpaceToView(fatherView, 17)
    .heightIs(1)
    .bottomEqualToView(fatherView)
    ;
}

-(void)setData:(NSDictionary *)data
{
    subTitle.textColor = HexColor(#F98B50);
    title.text = GetSaveString(data[@"title"]);
    subTitle.text = GetSaveString(data[@"rightTitle"]);
    NSString *imgStr = GetSaveString(data[@"img"]);
    if (UserGetBool(@"NightMode")) {
        imgStr = AppendingString(imgStr, @"_night");
    }
    icon.image = UIImageNamed(imgStr);
}

-(void)setSubTitleTextColor:(UIColor *)color
{
    subTitle.textColor = color;
}

@end
