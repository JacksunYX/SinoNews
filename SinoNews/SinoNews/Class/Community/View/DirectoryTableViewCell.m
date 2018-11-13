//
//  DirectoryTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/13.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "DirectoryTableViewCell.h"

NSString * const DirectoryTableViewCellID = @"DirectoryTableViewCellID";

@interface DirectoryTableViewCell ()
{
    UILabel *title;
    UIView *line;
}
@end

@implementation DirectoryTableViewCell

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
    line = [UIView new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 title,
                                 line,
                                 ]];
    title.sd_layout
    .leftSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .heightIs(20)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:250];
    title.font = PFFontL(16);
    
    line.sd_layout
    .centerYEqualToView(fatherView)
    .leftSpaceToView(title, 7)
    .rightSpaceToView(fatherView, 0)
    .heightIs(1)
    ;
}

-(void)setModel:(SeniorPostingAddElementModel *)model
{
    title.text = [NSString stringWithFormat:@"%@、%@",[NSString getChineseWithNum:model.sectionNum],GetSaveString(model.title)];
    [line removeAllSubviews];
    [line updateLayout];
    [line addBorderLineOnView:HexColor(#E3E3E3)];
}

@end
