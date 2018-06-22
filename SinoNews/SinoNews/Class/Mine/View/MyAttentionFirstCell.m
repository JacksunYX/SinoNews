//
//  MyAttentionFirstCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyAttentionFirstCell.h"

@interface MyAttentionFirstCell ()
{
    UILabel *title;
    UIImageView *img;
    UILabel *subTitle;
    UIButton *isAttention;
    
}
@end

@implementation MyAttentionFirstCell

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
    img = [UIImageView new];
    img.userInteractionEnabled = YES;
    
    isAttention = [UIButton new];
    isAttention.titleLabel.font = PFFontL(14);
    isAttention.tag = 10086;
    [isAttention addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    title = [UILabel new];
    title.font = PFFontL(16);
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(12);
    subTitle.textColor = HexColor(#888888);
    
    [self.contentView sd_addSubviews:@[
                              img,
                              isAttention,
                              title,
                              subTitle,
                              
                              ]];
    
    img.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    .widthIs(48)
    .heightEqualToWidth()
    ;
    [img setSd_cornerRadius:@24];
    img.backgroundColor = Arc4randomColor;
    
    isAttention.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(img)
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
    .leftSpaceToView(img, 10)
    .topSpaceToView(self.contentView, 23)
    .rightSpaceToView(isAttention, 10)
    .heightIs(16)
    ;
    title.text = @"这个杀手不太冷";
    
    subTitle.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(title, 9)
    .rightSpaceToView(isAttention, 10)
    .autoHeightRatio(0)
    ;
    subTitle.text = @"湖北省委机关报，湖北广告份额都市类报纸";
    
}

//关注点击事件
-(void)attentionAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = HexColor(#E3E3E3).CGColor;
    }else{
        btn.layer.borderColor = HexColor(#1282EE).CGColor;
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