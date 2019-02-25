//
//  MessageSystemNoticeTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2019/2/25.
//  Copyright © 2019 Sino. All rights reserved.
//

#import "MessageSystemNoticeTableViewCell.h"

NSString *const MessageSystemNoticeTableViewCellID = @"MessageSystemNoticeTableViewCellID";

@interface MessageSystemNoticeTableViewCell ()
{
    UILabel *mainText;
    UILabel *timeText;
}
@end

@implementation MessageSystemNoticeTableViewCell

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
    mainText = [UILabel new];
    timeText = [UILabel new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 mainText,
                                 timeText,
                                 ]];
    
    mainText.sd_layout
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 15)
    .topSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
    mainText.font = PFFontL(15);
    mainText.textColor = HexColor(#161A24);
    
    timeText.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(mainText, 15)
    .heightIs(14)
    ;
    timeText.font = PFFontL(15);
    timeText.textColor = HexColor(#818181);
    [timeText setSingleLineAutoResizeWithMaxWidth:100];
    
    [self setupAutoHeightWithBottomView:timeText bottomMargin:15];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    mainText.text = GetSaveString(model[@"title"]);
    timeText.text = GetSaveString(model[@"time"]);
}

@end
