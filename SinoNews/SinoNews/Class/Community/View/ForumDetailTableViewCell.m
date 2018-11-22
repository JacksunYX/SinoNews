//
//  ForumDetailTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumDetailTableViewCell.h"

NSString * _Nullable const ForumDetailTableViewCellID = @"ForumDetailTableViewCellID";

@interface ForumDetailTableViewCell ()
{
    UILabel *leftLabel; //左上角标签
    UILabel *content;   //内容
}
@end

@implementation ForumDetailTableViewCell

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
    leftLabel = [UILabel new];
    leftLabel.font = PFFontL(12);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    
    content = [UILabel new];
    content.font = PFFontL(13);
    content.numberOfLines = 2;
    
    [self.contentView sd_addSubviews:@[
                                       content,
                                       leftLabel,
                                       ]];
    content.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
//    .bottomSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
    //前面需要8个空格，不然标签会跟文字重叠，前提是标签只有2个字
    
    leftLabel.sd_layout
    .leftEqualToView(content)
    .topEqualToView(content)
    .widthIs(30)
    .heightIs(18)
    ;
    
    leftLabel.textColor = WhiteColor;
    leftLabel.sd_cornerRadius = @1;
    
    [self setupAutoHeightWithBottomView:content bottomMargin:10];
}

-(void)setData:(NSDictionary *)model
{
    content.text = [NSString stringWithFormat:@"        %@",GetSaveString(model[@"content"])];
    leftLabel.text = GetSaveString(model[@"label"]);
    if ([leftLabel.text isEqualToString:@"公告"]) {
        leftLabel.backgroundColor = HexColor(#FE0000);
        content.textColor = HexColor(#FE0000);
    }else{
        leftLabel.backgroundColor = HexColor(#FEB711);
        content.textColor = HexColor(#161A24);
    }
}


@end
