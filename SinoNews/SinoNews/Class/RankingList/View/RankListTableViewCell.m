//
//  RankDetailTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/1.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankListTableViewCell.h"

@interface RankListTableViewCell ()
{
    //左
    UIImageView *crown;
    UIImageView *userIcon;
    UIButton *num;   //排名
    //中
    UILabel *title; //标题
    UILabel *score; //分数
    UILabel *subTitle;
    UIImageView *status;
    //中
    UIButton *detailBtn;
    UIButton *toPlayBtn;
    UIImageView *upOrDown;
}
@end

@implementation RankListTableViewCell

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
    num.titleLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:14];
    num.titleLabel.textAlignment = NSTextAlignmentCenter;
    [num setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    crown = [UIImageView new];
    userIcon = [UIImageView new];
    userIcon.backgroundColor = WhiteColor;
    userIcon.userInteractionEnabled = YES;
    
    score = [UILabel new];
    score.font = PFFontL(14);
    score.textColor = RGBA(69, 69, 69, 1);
    
    status = [UIImageView new];
    status.contentMode = 1;
    
    title = [UILabel new];
    title.font = PFFontR(15);
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(14);
    subTitle.textColor = RGBA(111, 111, 111, 1);
    
    toPlayBtn = [UIButton new];
    toPlayBtn.titleLabel.font = PFFontL(14);
    toPlayBtn.backgroundColor = RGBA(107, 182, 255, 1);
    [toPlayBtn setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
//    toPlayBtn.layer.borderWidth = 1;
//    toPlayBtn.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
    @weakify(self)
    [[toPlayBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.toPlayBlock) {
            self.toPlayBlock();
        }
    }];
    
    detailBtn = [UIButton new];
    detailBtn.titleLabel.font = PFFontL(14);
    [detailBtn setTitleColor:RGBA(102, 102, 132, 1) forState:UIControlStateNormal];
    detailBtn.layer.borderWidth = 1;
    detailBtn.layer.borderColor = RGBA(102, 102, 132, 1).CGColor;
    
    [self.contentView sd_addSubviews:@[
                                       crown,
                                       userIcon,
                                       num,
                                       
                                       score,
                                       title,
                                       subTitle,
                                       status,
                                       
                                       toPlayBtn,
                                       detailBtn,

                                       ]];
}

-(void)setModel:(RankingListModel *)model
{
    _model = model;
//    NSString *imgStr = [NSString stringWithFormat:@"%@%@",defaultUrl,GetSaveString(model.companyLogo)];
    [userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(model.companyLogo))];
    [num setTitle:[NSString stringWithFormat:@"%lu",model.currentRank] forState:UIControlStateNormal];
    score.text = [NSString stringWithFormat:@"%lu分",model.currentScore];
    title.text = GetSaveString(model.companyName);
    subTitle.text = GetSaveString(model.promos);
    
    crown.image = nil;
    UIImage *numImg = UIImageNamed(@"rank_flag");
    userIcon.layer.borderWidth = 1;
    userIcon.layer.borderColor = ClearColor.CGColor;
    score.textColor = RGB(54, 54, 54);
    title.textColor = RGB(50, 50, 50);
    if (self.tag == 1) {
//        userIcon.layer.borderColor = HexColor(#ffc41f).CGColor;
//        crown.image = UIImageNamed(@"crown_first");
//        title.textColor = HexColor(#ffc41f);
        numImg = UIImageNamed(@"");
    }else if (self.tag == 2){
//        userIcon.layer.borderColor = HexColor(#1282ee).CGColor;
//        crown.image = UIImageNamed(@"crown_second");
//        title.textColor = HexColor(#1282ee);
        numImg = UIImageNamed(@"");
    }else if (self.tag == 3){
//        userIcon.layer.borderColor = HexColor(#f29f00).CGColor;
//        crown.image = UIImageNamed(@"crown_third");
//        title.textColor = HexColor(#f29f00);
        numImg = UIImageNamed(@"");
    }else{
//        userIcon.layer.borderColor = HexColor(#dbdbdb).CGColor;
        score.textColor = RGB(152, 152, 152);
    }
    [num setBackgroundImage:numImg forState:UIControlStateNormal];
    
    switch (self.model.status) {
        case -1:
            status.image = UIImageNamed(@"down_icon");
            break;
        case 0:
            status.image = UIImageNamed(@"invariable_icon");
            break;
        case 1:
            status.image = UIImageNamed(@"up_icon");
            break;
        default:
            break;
    }
    
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //布局
    if (self.model.currentRank < 4) {
        userIcon.sd_layout
        .leftSpaceToView(self.contentView, 30)
        .centerYEqualToView(self.contentView)
        .widthIs(80)
        .heightEqualToWidth()
        ;
        [userIcon setSd_cornerRadius:@40];
        
        num.sd_layout
        .topSpaceToView(self.contentView, 9)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(31)
        .heightIs(41)
        ;
        num.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        toPlayBtn.sd_layout
        .widthIs(67 * ScaleW)
        .heightIs(28)
        .rightSpaceToView(self.contentView, 15)
        .bottomSpaceToView(self.contentView, 19)
        ;
        
        detailBtn.hidden = NO;
        detailBtn.sd_layout
        .widthIs(67 * ScaleW)
        .heightIs(28)
        .rightSpaceToView(self.contentView, 15)
        .bottomSpaceToView(toPlayBtn, 8)
        ;
        
        score.sd_layout
        .leftSpaceToView(userIcon, 23 * ScaleW)
        .centerYEqualToView(self.contentView)
        .widthIs(60)
        .heightIs(14)
        ;
        
        subTitle.sd_layout
        .leftEqualToView(score)
        .topSpaceToView(score, 11)
        .heightIs(14)
        ;
        [subTitle setSingleLineAutoResizeWithMaxWidth:150 * ScaleW];
        
    }else{
        userIcon.sd_layout
        .leftSpaceToView(self.contentView, 43)
        .centerYEqualToView(self.contentView)
        .widthIs(54)
        .heightEqualToWidth()
        ;
        [userIcon setSd_cornerRadius:@27];
        
        num.sd_layout
        .topSpaceToView(self.contentView, 26)
        .leftSpaceToView(self.contentView, 14)
        .widthIs(24)
        .heightIs(21)
        ;
        num.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        
        detailBtn.hidden = YES;
        toPlayBtn.sd_layout
        .widthIs(67 * ScaleW)
        .heightIs(28)
        .rightSpaceToView(self.contentView, 15)
        .centerYEqualToView(self.contentView)
        ;
        
        score.sd_layout
        .leftSpaceToView(userIcon, 35 * ScaleW)
        .bottomSpaceToView(self.contentView, 15)
        .widthIs(60)
        .heightIs(14)
        ;
        
        subTitle.hidden = YES;
    }
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [toPlayBtn setTitle:@"去玩" forState:UIControlStateNormal];
    
    title.sd_layout
    .leftEqualToView(score)
    .bottomSpaceToView(score, 11)
    .heightIs(15)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:120 * ScaleW];
    
    status.sd_layout
    .leftSpaceToView(score, 15)
    .centerYEqualToView(score)
    .widthIs(11)
    .heightIs(14)
    ;
    
}




@end
