//
//  RankDetailTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankDetailTableViewCell.h"

@interface RankDetailTableViewCell ()
{
    //左
    UIImageView *crown;
    UIImageView *userIcon;
    UIButton *num;   //排名
    //中
    UILabel *title; //标题
    UILabel *score; //分数
    UILabel *subTitle;
    //中
    UIButton *detailBtn;
    UIButton *toPlayBtn;
    UIImageView *upOrDown;
}
@end

@implementation RankDetailTableViewCell

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
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    num = [UIButton new];
    num.titleLabel.font = BoldFont(12);
    num.titleLabel.textAlignment = NSTextAlignmentCenter;
    [num setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    crown = [UIImageView new];
    userIcon = [UIImageView new];
    
    score = [UILabel new];
    score.font = Font(15);
    
    title = [UILabel new];
    title.font = Font(15);
    
    subTitle = [UILabel new];
    subTitle.font = Font(14);
    
    toPlayBtn = [UIButton new];
    toPlayBtn.titleLabel.font = Font(15);
    [toPlayBtn setTitleColor:RGBA(238, 174, 38, 1) forState:UIControlStateNormal];
    toPlayBtn.layer.borderWidth = 1;
    toPlayBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
    
    detailBtn = [UIButton new];
    detailBtn.titleLabel.font = Font(15);
    [detailBtn setTitleColor:RGBA(78, 152, 223, 1) forState:UIControlStateNormal];
    detailBtn.layer.borderWidth = 1;
    detailBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
    
    upOrDown = [UIImageView new];
    
    [self.contentView sd_addSubviews:@[
                                       num,
                                       crown,
                                       userIcon,
                                       
                                       score,
                                       title,
                                       subTitle,
                                       
                                       toPlayBtn,
                                       detailBtn,
                                       upOrDown,
                                       ]];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    
    userIcon.image = UIImageNamed(GetSaveString(model[@"userIcon"]));
    
    [num setTitle:[NSString stringWithFormat:@"%ld",self.tag] forState:UIControlStateNormal];
    score.text = model[@"score"];
    title.text = model[@"title"];
    subTitle.text = model[@"subTitle"];
    
    [num setBackgroundImage:UIImageNamed(@"rank_medal") forState:UIControlStateNormal];
    crown.image = nil;
    userIcon.layer.borderWidth = 1.5;
    userIcon.layer.borderColor = ClearColor.CGColor;
    score.textColor = RGB(54, 54, 54);
    title.textColor = RGB(50, 50, 50);
    if (self.tag == 1) {
        userIcon.layer.borderColor = HexColor(#ffc41f).CGColor;
        crown.image = UIImageNamed(@"crown_first");
        title.textColor = HexColor(#ffc41f);
    }else if (self.tag == 2){
        userIcon.layer.borderColor = HexColor(#1282ee).CGColor;
        crown.image = UIImageNamed(@"crown_second");
        title.textColor = HexColor(#1282ee);
    }else if (self.tag == 3){
        userIcon.layer.borderColor = HexColor(#f29f00).CGColor;
        crown.image = UIImageNamed(@"crown_third");
        title.textColor = HexColor(#f29f00);
    }else{
        userIcon.layer.borderColor = HexColor(#dbdbdb).CGColor;
        [num setBackgroundImage:UIImageNamed(@"rank_flag") forState:UIControlStateNormal];
        score.textColor = RGB(152, 152, 152);
    }
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //布局
    if (self.tag < 4) {
        
        num.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 6)
        .widthIs(22)
        .heightIs(26)
        ;
        num.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
    }else{
        num.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 6)
        .widthIs(24)
        .heightIs(21)
        ;
        num.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    crown.sd_layout
    .topSpaceToView(self.contentView, 6)
    .leftSpaceToView(num, 12)
    .widthIs(51)
    .heightIs(35)
    ;
    
    if (self.tag < 4) {
        userIcon.sd_layout
        .bottomSpaceToView(self.contentView, 5)
        .centerXEqualToView(crown)
        .widthIs(54)
        .heightEqualToWidth()
        ;
    }else{
        userIcon.sd_layout
        .centerYEqualToView(self.contentView)
        .centerXEqualToView(crown)
        .widthIs(54)
        .heightEqualToWidth()
        ;
    }
    
    userIcon.userInteractionEnabled = YES;
    [userIcon setSd_cornerRadius:@27];
    
    score.sd_layout
    .leftSpaceToView(userIcon, 30)
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0)
    ;
    [score setMaxNumberOfLinesToShow:1];
    [score setSingleLineAutoResizeWithMaxWidth:100];
    
    title.sd_layout
    .leftEqualToView(score)
    .bottomSpaceToView(score, 0)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:1];
    [title setSingleLineAutoResizeWithMaxWidth:100];
    
    subTitle.sd_layout
    .leftEqualToView(score)
    .topSpaceToView(score, 0)
    .autoHeightRatio(0)
    ;
    [subTitle setMaxNumberOfLinesToShow:1];
    [subTitle setSingleLineAutoResizeWithMaxWidth:100];
    
    if (self.tag < 4) {
        toPlayBtn.sd_layout
        .widthIs(55)
        .heightIs(21)
        .rightSpaceToView(self.contentView, 5)
        .bottomSpaceToView(self.contentView, 10)
        ;
        
        detailBtn.hidden = NO;
        detailBtn.sd_layout
        .widthIs(55)
        .heightIs(21)
        .rightSpaceToView(self.contentView, 5)
        .bottomSpaceToView(toPlayBtn, 8)
        ;
    }else{
        detailBtn.hidden = YES;
        toPlayBtn.sd_layout
        .widthIs(55)
        .heightIs(21)
        .rightSpaceToView(self.contentView, 5)
        .centerYEqualToView(self.contentView)
        ;
    }
    [toPlayBtn setSd_cornerRadius:@4];
    [detailBtn setSd_cornerRadius:@4];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [toPlayBtn setTitle:@"去玩" forState:UIControlStateNormal];
    
    upOrDown.sd_layout
    .rightSpaceToView(toPlayBtn, 50)
    .topSpaceToView(self.contentView, 20)
    .widthIs(11)
    .heightIs(14)
    ;
    
    if ([self.model[@"upOrDown"] integerValue]) {
        upOrDown.image = UIImageNamed(@"up_icon");
    }else{
        upOrDown.image = UIImageNamed(@"down_icon");
    }
}




@end
