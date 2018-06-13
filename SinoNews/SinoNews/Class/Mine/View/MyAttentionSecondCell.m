//
//  MyAttentionSecondCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyAttentionSecondCell.h"

@interface MyAttentionSecondCell ()
{
    UILabel *title;
    UILabel *fansNum;
    UILabel *subTitle;
    UIButton *isAttention;
}
@end

@implementation MyAttentionSecondCell

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
    title.font = PFFontL(16);
    
    fansNum = [UILabel new];
    fansNum.font = PFFontL(12);
    fansNum.textColor = RGBA(136, 136, 136, 1);
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(12);
    
    isAttention = [UIButton new];
    isAttention.titleLabel.font = PFFontL(14);
    [isAttention addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView sd_addSubviews:@[
                                       isAttention,
                                       title,
                                       fansNum,
                                       subTitle,
                                       ]];
    isAttention.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 24)
    .widthIs(50)
    .heightIs(22)
    ;
    isAttention.backgroundColor = WhiteColor;
    [isAttention setTitle:@"关注" forState:UIControlStateNormal];
    [isAttention setTitle:@"已关注" forState:UIControlStateSelected];
    
    [isAttention setTitleColor:HexColor(#1282EE) forState:UIControlStateNormal];
    [isAttention setTitleColor:HexColor(#989898) forState:UIControlStateSelected];
    
    isAttention.layer.borderColor = HexColor(#1282EE).CGColor;
    isAttention.layer.borderWidth = 1;
    isAttention.layer.cornerRadius = 2;
    
    title.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(isAttention, 10)
    .heightIs(16)
    ;
    title.text = @"#军武次位面#";
    
    fansNum.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(title, 4)
    .rightEqualToView(title)
    .heightIs(12)
    ;
    fansNum.text = @"445 粉丝";
    
    subTitle.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(fansNum, 15)
    .rightSpaceToView(self.contentView, 30)
    .autoHeightRatio(0)
    ;
    [subTitle setMaxNumberOfLinesToShow:3];
    subTitle.text = @"《军武次位面》是知名的网络军事类视频节目，注重调侃娱乐性，但是其在专业深度上也毫不逊色。当有新节目更新时我们提醒你。";
}

-(void)attentionAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        isAttention.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        isAttention.layer.borderColor = HexColor(#1282EE).CGColor;
    }
    
    if (self.attentionIndex) {
        self.attentionIndex(self.tag);
    }
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
}

@end
