//
//  MyFansTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/2.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "MyFansTableViewCell.h"

@interface MyFansTableViewCell ()
{
    UIImageView *fansIcon;
    UILabel *fansName;
    UIImageView *sex;
    UIButton *attentionBtn;
}
@end

@implementation MyFansTableViewCell

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
    fansIcon = [UIImageView new];
    fansName = [UILabel new];
    [fansName addTitleColorTheme];
    sex = [UIImageView new];
    attentionBtn = [UIButton new];
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 fansIcon,
                                 fansName,
                                 sex,
                                 attentionBtn,
                                 ]];
    fansIcon.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(45)
    .heightEqualToWidth()
    ;
    [fansIcon setSd_cornerRadius:@(45/2)];
//    fansIcon.backgroundColor = Arc4randomColor;
    
    fansName.sd_layout
    .centerYEqualToView(fansIcon)
    .leftSpaceToView(fansIcon, 10)
    .heightIs(18)
    ;
    [fansName setSingleLineAutoResizeWithMaxWidth:150];
//    fansName.text = @"╰☆叶枫〆";
    
    sex.sd_layout
    .leftSpaceToView(fansName, 10)
    .centerYEqualToView(fansIcon)
    .widthIs(19)
    .heightEqualToWidth()
    ;
    
    
    attentionBtn.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(fansIcon)
    .widthIs(45)
    .heightIs(20)
    ;
    [attentionBtn setSd_cornerRadius:@10];
    [attentionBtn setImage:UIImageNamed(@"myFans_unAttention") forState:UIControlStateNormal];
    [attentionBtn setImage:UIImageNamed(@"myFans_attentioned") forState:UIControlStateSelected];
    [attentionBtn setBackgroundImage:[UIImage imageWithColor:RGBA(18, 130, 238, 1)] forState:UIControlStateNormal];
    [attentionBtn setBackgroundImage:[UIImage imageWithColor:RGBA(227, 227, 227, 1)] forState:UIControlStateSelected];
    @weakify(self)
    [[attentionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.attentionBlock) {
            self.attentionBlock();
        }
    }];
    
    [self setupAutoHeightWithBottomView:fansIcon bottomMargin:10];
}

-(void)setType:(NSInteger)type
{
    _type = type;
    if (type == 1) {
        [attentionBtn setImage:UIImageNamed(@"myFans_tick") forState:UIControlStateSelected];
    }
}

-(void)setModel:(MyFansModel *)model
{
    _model = model;
    
    attentionBtn.selected = model.isFollow;
    
    sex.image = nil;
    if (model.gender == 1) {
        sex.image = UIImageNamed(@"message_man");
    }else if (model.gender == 0){
        sex.image = UIImageNamed(@"message_woman");
    }
    
    fansName.text = GetSaveString(model.username);
    
    [fansIcon sd_setImageWithURL:UrlWithStr(GetSaveString(model.avatar))];
}


@end
