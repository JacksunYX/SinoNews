//
//  RankListTableViewCell2.m
//  SinoNews
//
//  Created by Michael on 2018/10/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "RankListTableViewCell2.h"

@interface RankListTableViewCell2 ()
{
    //左
    FLAnimatedImageView *userIcon;
    //中
    UILabel *num;   //排名
    UIImageView *guarantee; //担保标签
    UILabel *title; //标题
    UILabel *score; //分数
    UILabel *subTitle;
    //右
    UIButton *toPlayBtn;
    UIImageView *status;
}
@end

@implementation RankListTableViewCell2

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
    userIcon = [FLAnimatedImageView new];
//    userIcon.backgroundColor = Arc4randomColor;
    
    num = [UILabel new];
    num.font = PFFontR(15);
    [num addTitleColorTheme];
    
    guarantee = [UIImageView new];
    
    title = [UILabel new];
    title.font = PFFontR(15);
    [title addTitleColorTheme];
    
    score = [UILabel new];
    score.font = PFFontL(15);
    [score addTitleColorTheme];
    
    subTitle = [UILabel new];
    subTitle.font = PFFontL(13);
    [subTitle addContentColorTheme];
    
    toPlayBtn = [UIButton new];
    [toPlayBtn setBtnFont:PFFontL(14)];
    toPlayBtn.backgroundColor = HexColor(#1282EE);
    [toPlayBtn setNormalTitleColor:WhiteColor];
    
    status = [UIImageView new];
    status.contentMode = 1;
    
    UIView *line = [UIView new];
    [line addCutLineColor];
    
    [self.contentView sd_addSubviews:@[
                                       userIcon,
                                       toPlayBtn,
                                       num,
                                       score,
                                       status,
                                       title,
                                       subTitle,
                                       guarantee,
                                       line,
                                       ]];
    UIView *fatherView = self.contentView;
    userIcon.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 10)
    .widthIs(62)
    .heightEqualToWidth()
    ;
    userIcon.sd_cornerRadius = @16;
    
    toPlayBtn.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(userIcon)
    .widthIs(67)
    .heightIs(28)
    ;
    toPlayBtn.sd_cornerRadius = @14;
    [toPlayBtn setNormalTitle:@"去玩"];
    
    num.sd_layout
    .leftSpaceToView(userIcon, 10)
    .topSpaceToView(fatherView, 20)
    .heightIs(16)
    ;
    [num setSingleLineAutoResizeWithMaxWidth:50];
//    num.text = @"1";
    
    score.sd_layout
    .rightSpaceToView(toPlayBtn, 50)
    .centerYEqualToView(num)
    .heightIs(16)
    ;
    [score setSingleLineAutoResizeWithMaxWidth:100];
//    score.text = @"99.5分";
    
    status.sd_resetLayout
    .leftSpaceToView(score, 10)
    .centerYEqualToView(score)
    .widthIs(11)
    .heightIs(14)
    ;
    
    title.sd_layout
    .leftSpaceToView(num, 10)
    .rightSpaceToView(score, 10)
    .centerYEqualToView(num)
    .heightIs(16)
    ;
//    title.text = @"XXX娱乐场";
    
    subTitle.sd_layout
    .leftEqualToView(title)
    .rightSpaceToView(toPlayBtn, 10)
    .topSpaceToView(title, 10)
    .heightIs(16)
    ;
    
    guarantee.sd_layout
    .centerXEqualToView(num)
    .centerYEqualToView(subTitle)
    .widthIs(22)
    .heightIs(12)
    ;
    guarantee.image = UIImageNamed(@"rankGuarantee");
    guarantee.hidden = YES;
    
    line.sd_layout
    .bottomEqualToView(fatherView)
    .leftSpaceToView(userIcon, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:userIcon bottomMargin:10];
}

-(void)setModel:(RankingListModel *)model
{
    _model = model;
    [userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(model.companyLogo))];
    [num setText:[NSString stringWithFormat:@"%ld",(long)model.currentRank]];
    score.text = [NSString stringWithFormat:@"%.1f分",model.currentScore];
    title.text = GetSaveString(model.companyName);
    subTitle.text = GetSaveString(model.promos);
    
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
    
    @weakify(self);
    [toPlayBtn whenTap:^{
        @strongify(self);
        if (self.toPlayBlock) {
            self.toPlayBlock(self.tag);
        }
    }];
}

@end
