//
//  FansTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "FansTableViewCell.h"

@interface FansTableViewCell ()
{
    UILabel *name;
    UILabel *time;

    UIImageView *icon;
    UIImageView *sex;
}
@end

@implementation FansTableViewCell

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
    
    sex = [UIImageView new];
    
    name = [UILabel new];
    name.font = PFFontL(16);
    
    time = [UILabel new];
    time.font = PFFontL(11);
    time.textColor = RGBA(152, 152, 152, 1);
    time.textAlignment = NSTextAlignmentRight;
    
    UILabel *attention = [UILabel new];
    attention.font = PFFontL(16);
    
    UIView *fatherView = self.contentView;
    
    [fatherView sd_addSubviews:@[
                                 icon,
                                 time,
                                 name,
                                 sex,
                                 attention,
                                 ]];
    icon.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(fatherView, 10)
    .widthIs(45)
    .heightEqualToWidth()
    ;
    [icon setSd_cornerRadius:@(45/2)];
    
    time.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .heightIs(12)
    ;
    [time setSingleLineAutoResizeWithMaxWidth:100];
    
    name.sd_layout
    .leftSpaceToView(icon, 10)
    .centerYEqualToView(fatherView)
    .heightIs(20)
    ;
    [name setSingleLineAutoResizeWithMaxWidth:150];
    
    sex.sd_layout
    .leftSpaceToView(name, 10)
    .centerYEqualToView(fatherView)
    .widthIs(18)
    .heightEqualToWidth()
    ;
    
    attention.sd_layout
    .leftSpaceToView(sex, 30)
    .centerYEqualToView(fatherView)
    .heightIs(20)
    ;
    [attention setSingleLineAutoResizeWithMaxWidth:150];
    attention.text = @"关注了你";
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    name.text = GetSaveString(model[@"name"]);
    time.text = GetSaveString(model[@"time"]);
    
    icon.image = UIImageNamed(GetSaveString(model[@"icon"]));
    
    sex.hidden = NO;
    switch ([model[@"sex"] integerValue]) {
        case 0: //无性别
        {
            sex.hidden = YES;
        }
            break;
        case 1: //男
        {
            sex.image = UIImageNamed(@"message_man");
        }
            break;
        case 2: //女
        {
            sex.image = UIImageNamed(@"message_woman");
        }
            break;
            
        default:
            break;
    }
}

@end
