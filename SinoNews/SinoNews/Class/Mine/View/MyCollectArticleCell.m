//
//  MyCollectArticleCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/13.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyCollectArticleCell.h"

@interface MyCollectArticleCell ()
{
    UIImageView *img;
    UILabel *title;
    UILabel *introduce;
}
@end

@implementation MyCollectArticleCell

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
        UIView *backView = [UIView new];
        backView.backgroundColor = WhiteColor;
        self.selectedBackgroundView = backView;
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    img = [UIImageView new];
//    img.backgroundColor = Arc4randomColor;
    
    title = [UILabel new];
    title.font = PFFontL(15);
    
    introduce = [UILabel new];
    introduce.font = PFFontL(12);
    introduce.textColor = RGBA(152, 152, 152, 1);
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 img,
                                 title,
                                 introduce,
                                 ]];
    img.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(130)
    .heightIs(80)
    ;
    [img setSd_cornerRadius:@4];
    
    title.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 9)
    .rightSpaceToView(img, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    title.text = @"中移动退出国内首款eSIM芯片 未来候机无需在插卡";
    
    introduce.sd_layout
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(img, 20)
    .bottomSpaceToView(fatherView, 17)
    .heightIs(12)
    ;
    introduce.text = @"5-25 13:45 | 张少华";
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
}




@end
