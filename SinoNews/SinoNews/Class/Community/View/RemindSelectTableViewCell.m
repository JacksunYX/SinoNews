//
//  RemindSelectTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/6.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "RemindSelectTableViewCell.h"

NSString * _Nullable const RemindSelectTableViewCellID = @"RemindSelectTableViewCellID";

@interface RemindSelectTableViewCell ()
{
    UIImageView *avatar;
    UILabel     *nickname;
    UIButton    *selectBtn;
}
@end

@implementation RemindSelectTableViewCell

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
    avatar = [UIImageView new];
    nickname = [UILabel new];
    nickname.textColor = HexColor(#161A24);
    nickname.font = PFFontL(15);
    selectBtn = [UIButton new];
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 nickname,
                                 selectBtn,
                                 
                                 ]];
    avatar.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(38)
    .heightEqualToWidth()
    ;
    avatar.sd_cornerRadius = @19;
//    avatar.backgroundColor = Arc4randomColor;
    
    nickname.sd_layout
    .leftSpaceToView(avatar, 14)
    .centerYEqualToView(fatherView)
    .heightIs(18)
    ;
    [nickname setSingleLineAutoResizeWithMaxWidth:150];
    nickname.text = @"哈哈哈维生素";
    
    selectBtn.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fatherView)
    .widthIs(23)
    .heightEqualToWidth()
    ;
    [selectBtn setNormalImage:UIImageNamed(@"remindRead_noSelect")];
    [selectBtn setSelectedImage:UIImageNamed(@"remindRead_selected")];
    
    [self setupAutoHeightWithBottomView:avatar bottomMargin:10];
}

-(void)setModel:(RemindPeople *)model
{
    _model = model;
    [avatar sd_setImageWithURL:UrlWithStr(model.avatar)];
    nickname.text = model.username;
    selectBtn.selected = model.isSelected;
}

@end
