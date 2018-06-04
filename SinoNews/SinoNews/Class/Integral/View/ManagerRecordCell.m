//
//  ManagerRecordCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerRecordCell.h"

@interface ManagerRecordCell ()
{
    UILabel *behavior;
    UILabel *time;
    UILabel *integerChange;
    UILabel *balance;
}
@end

@implementation ManagerRecordCell

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
        self.backgroundColor = WhiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = RGBA(227, 227, 227, 1);
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = RGBA(227, 227, 227, 1);
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 leftLine,
                                 rightLine,
                                 bottomLine,
                                 ]];
    
    leftLine.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    rightLine.sd_layout
    .rightSpaceToView(fatherView, 10)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    bottomLine.sd_layout
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(fatherView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    
    behavior = [UILabel new];
    behavior.font = Font(13);
    behavior.textColor = RGBA(68, 68, 68, 1);
    
    time = [UILabel new];
    time.font = Font(12);
    time.textColor = RGBA(152, 152, 152, 1);
    
    integerChange = [UILabel new];
    integerChange.font = Font(12);
    integerChange.textColor = RGBA(118, 179, 239, 1);
    
    balance = [UILabel new];
    balance.font = Font(12);
    balance.textColor = RGBA(152, 152, 152, 1);
    
    [fatherView sd_addSubviews:@[
                                 behavior,
                                 time,
                                 integerChange,
                                 balance,
                                 ]];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
}





@end
