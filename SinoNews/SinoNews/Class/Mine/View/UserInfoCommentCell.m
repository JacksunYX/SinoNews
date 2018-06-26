//
//  UserInfoCommentCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/26.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "UserInfoCommentCell.h"

@interface UserInfoCommentCell ()
{
    UIImageView *avatar;
    UILabel *username;
    UILabel *comment;
    UILabel *createTime;
    UIButton *praise;   //点赞
    
    UIImageView *articleImg;
    UILabel *articleTitle;
}
@end

@implementation UserInfoCommentCell

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
    avatar = [UIImageView new];
    
    praise = [UIButton new];
    [praise setTitleColor:RGBA(50, 50, 50, 1) forState:UIControlStateNormal];
    praise.titleLabel.font = PFFontR(14);
    
    username = [UILabel new];
    username.font = PFFontR(13);
    
    comment = [UILabel new];
    comment.font = PFFontL(15);
    comment.numberOfLines = 0;
    
    createTime = [UILabel new];
    createTime.font = PFFontL(11);
    createTime.textColor = RGBA(152, 152, 152, 1);

    UIView *bottomBackView = [UIView new];
    bottomBackView.backgroundColor = RGBA(227, 227, 227, 1);
    
    UIView *fatherView = self.contentView;
    
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 praise,
                                 username,
                                 comment,
                                 createTime,
                                 bottomBackView,
                                 ]];
    
    avatar.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(24)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@12];
    avatar.backgroundColor = Arc4randomColor;
    
    praise.sd_layout
    .rightSpaceToView(fatherView, 16)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [praise setImage:UIImageNamed(@"company_unPraise") forState:UIControlStateNormal];
    [praise setImage:UIImageNamed(@"company_praised") forState:UIControlStateSelected];
    
    username.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 5)
    .heightIs(14)
    .rightSpaceToView(praise, 20)
    ;
    
    comment.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(username, 14)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
    //    comment.backgroundColor = Arc4randomColor;
    
    createTime.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(comment, 14)
    .heightIs(11)
    ;
    [createTime setSingleLineAutoResizeWithMaxWidth:50];
    
    bottomBackView.sd_layout
    .leftEqualToView(username)
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(createTime, 10)
    .heightIs(50)
    ;
    
    //下半部分
    articleImg = [UIImageView new];
    articleImg.backgroundColor = Arc4randomColor;
    
    articleTitle = [UILabel new];
    articleTitle.font = PFFontL(11);
    articleTitle.textColor = RGBA(152, 152, 152, 1);
    
    [bottomBackView sd_addSubviews:@[
                                     articleImg,
                                     articleTitle,
                                     ]];
    articleImg.sd_layout
    .leftEqualToView(bottomBackView)
    .centerYEqualToView(bottomBackView)
    .heightRatioToView(bottomBackView, 1)
    .widthEqualToHeight()
    ;
    
    articleTitle.sd_layout
    .leftSpaceToView(articleImg, 10)
    .rightSpaceToView(bottomBackView, 10)
    .topSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    [articleTitle setMaxNumberOfLinesToShow:2];
    
    [self setupAutoHeightWithBottomView:bottomBackView bottomMargin:10];
    
}

- (void)setModel:(NSDictionary *)model
{
    _model = model;
    
    avatar.image = UIImageNamed(@"user_icon");
    username.text = @"曾许诺";
    praise.selected = YES;
    [praise setTitle:@"23" forState:UIControlStateNormal];
    
    comment.text = @"抗日神剧就是这样，是神剧";
    createTime.text = @"18分钟前";
    articleImg.image = UIImageNamed(@"logo_youku");
    articleTitle.text = @"日本人如何看待抗日神剧中“手撕鬼子”？";
}

@end
