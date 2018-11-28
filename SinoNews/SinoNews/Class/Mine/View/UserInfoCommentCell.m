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
    UILabel *ip;
    UILabel *createTime;
    UIButton *praise;   //点赞
    UIView *bottomBackView;
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
    [username addTitleColorTheme];
    
    comment = [UILabel new];
    comment.font = PFFontL(15);
    comment.numberOfLines = 0;
    [comment addTitleColorTheme];
    
    ip = [UILabel new];
    ip.font = PFFontL(11);
    ip.textColor = RGBA(152, 152, 152, 1);
    
    createTime = [UILabel new];
    createTime.font = PFFontL(11);
    createTime.textColor = RGBA(152, 152, 152, 1);

    bottomBackView = [UIView new];
//    bottomBackView.backgroundColor = RGBA(227, 227, 227, 1);
    bottomBackView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:HexColor(#292D30)];
        }else{
            [(UIView *)item setBackgroundColor:RGBA(227, 227, 227, 1)];
        }
    });
    
    UIView *sepLine = [UIView new];
    [sepLine addCutLineColor];
    
    UIView *fatherView = self.contentView;
    
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 praise,
                                 username,
                                 comment,
                                 ip,
                                 createTime,
                                 bottomBackView,
                                 sepLine,
                                 ]];
    
    avatar.sd_layout
    .topSpaceToView(fatherView, 10)
    .leftSpaceToView(fatherView, 10)
    .widthIs(24)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@12];
//    avatar.backgroundColor = Arc4randomColor;
    
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
    praise.hidden = YES;
    
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
    
    ip.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(comment, 14)
    .heightIs(11)
    ;
    [ip setSingleLineAutoResizeWithMaxWidth:100];
    
    createTime.sd_layout
    .leftSpaceToView(ip, 10)
//    .topSpaceToView(comment, 14)
    .centerYEqualToView(ip)
    .heightIs(11)
    ;
    [createTime setSingleLineAutoResizeWithMaxWidth:80];
    
    bottomBackView.sd_layout
    .leftEqualToView(username)
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(createTime, 10)
    .heightIs(50)
    ;
    
    sepLine.sd_layout
    .leftEqualToView(username)
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(bottomBackView, 10)
    .heightIs(1)
    ;
    
    //下半部分
    articleImg = [UIImageView new];
//    articleImg.backgroundColor = Arc4randomColor;
    
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
    
    [self setupAutoHeightWithBottomView:sepLine bottomMargin:0];
    
}

- (void)setModel:(CompanyCommentModel *)model
{
    _model = model;
    
    [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(model.avatar)) placeholderImage:UIImageNamed(@"loading_placeholder_w")];
    username.text = GetSaveString(model.username);
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        if (self.clickNewBlock) {
            self.clickNewBlock();
        }
    }];
    [bottomBackView addGestureRecognizer:tap];
    
    comment.text = GetSaveString(model.comment);
    
    ip.text = GetSaveString(model.ip);
    
    createTime.text = GetSaveString(model.createTime);

    if (model.newsImages.count) {
        NSString *imgStr = model.newsImages[0];
        [articleImg sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:UIImageNamed(@"loading_placeholder_w")];
    }
    articleTitle.text = GetSaveString(model.title);
}

-(void)setPostReplyModel:(PostReplyModel *)postReplyModel
{
    _postReplyModel = postReplyModel;
    [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(postReplyModel.avatar)) placeholderImage:UIImageNamed(@"loading_placeholder_w")];
    username.text = GetSaveString(postReplyModel.username);
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    @weakify(self)
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        if (self.clickNewBlock) {
            self.clickNewBlock();
        }
    }];
    [bottomBackView addGestureRecognizer:tap];
    
    comment.text = GetSaveString(postReplyModel.comment);
    
    createTime.text = GetSaveString(postReplyModel.createTime);
    
    if (postReplyModel.image) {
        [articleImg sd_setImageWithURL:UrlWithStr(GetSaveString(postReplyModel.image)) placeholderImage:UIImageNamed(@"loading_placeholder_w")];
    }
    articleTitle.text = GetSaveString(postReplyModel.postTitle);
}

@end
