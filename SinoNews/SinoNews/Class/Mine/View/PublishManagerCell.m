//
//  PublishManagerCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/10.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PublishManagerCell.h"

@interface PublishManagerCell()
{
    UIImageView *avatar;
    UILabel     *username;
    UILabel     *creatTime;
    UILabel     *newTitle;
    UIImageView *popView;
    UILabel     *viewCount; //阅读量
    
    UIImageView *newsCover; //封面
    
    UIButton    *share;
    UIButton    *comment;
    UIButton    *praise;
}
@end

@implementation PublishManagerCell

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
        [self addBakcgroundColorTheme];
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    avatar = [UIImageView new];
    
    username    = [UILabel new];
    username.font = PFFontL(16);
    [username addTitleColorTheme];
    
    creatTime   = [UILabel new];
    creatTime.font = PFFontL(11);
    creatTime.textColor = RGBA(152, 152, 152, 1);
    
    newTitle    = [UILabel new];
    newTitle.font = PFFontL(15);
    [newTitle addTitleColorTheme];
    
    popView = [UIImageView new];
    
    viewCount   = [UILabel new];
    viewCount.textColor = RGBA(152, 152, 152, 1);
    viewCount.font = PFFontL(10);
    viewCount.textAlignment = NSTextAlignmentCenter;
    viewCount.numberOfLines = 2;
    
    newsCover = [UIImageView new];
    newsCover.contentMode = 3;
    
    share   = [UIButton new];
    share.titleLabel.font = PFFontL(12);
    [share setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    
    comment = [UIButton new];
    comment.titleLabel.font = PFFontR(16);
    [comment setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    
    praise  = [UIButton new];
    praise.titleLabel.font = PFFontR(16);
    [praise setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    
    [self.contentView sd_addSubviews:@[
                                 avatar,
                                 username,
                                 creatTime,
                                 newTitle,
                                 popView,
                                 viewCount,
                                 
                                 newsCover,
                                 
                                 share,
                                 comment,
                                 praise,
                                 
                                 ]];
    
    [self sdLoadViews];
    
    [self setupAutoHeightWithBottomViewsArray:@[share,comment,praise] bottomMargin:10];
}

//布局
-(void)sdLoadViews
{
    UIView *fatherView = self.contentView;
    
    avatar.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 19)
    .widthIs(46)
    .heightEqualToWidth()
    ;
    avatar.backgroundColor = Arc4randomColor;
    [avatar setSd_cornerRadius:@23];
    
    username.sd_layout
    .topSpaceToView(fatherView, 27)
    .leftSpaceToView(avatar, 10)
    .heightIs(16)
    ;
    [username setSingleLineAutoResizeWithMaxWidth:100];
//    username.text = @"赠许诺";
    
    creatTime.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(username, 6)
    .heightIs(12)
    ;
    [creatTime setSingleLineAutoResizeWithMaxWidth:150];
//    creatTime.text = @"18-06-04";
    
    newTitle.sd_layout
    .topSpaceToView(avatar, 10)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
//    newTitle.text = @"习近平总书记两院士大会重要讲话激励香港科学家";
    
    popView.sd_layout
    .topSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .widthIs(13)
    .heightIs(8)
    ;
    popView.image = UIImageNamed(@"publish_operate");
    
    viewCount.sd_layout
    .topSpaceToView(popView, 10)
    .rightSpaceToView(fatherView, 10)
    .widthIs(60)
    .heightIs(30)
    ;
//    viewCount.text = @"690\n阅读";
    viewCount.layer.borderColor = RGBA(227, 227, 227, 1).CGColor;
    viewCount.layer.borderWidth = 1;
    
    newsCover.sd_layout
    .topSpaceToView(newTitle, 15)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 10)
    .heightIs((ScreenW - 20)*150/355)
    ;
//    newsCover.backgroundColor = Arc4randomColor;
    
    share.sd_layout
    .leftSpaceToView(fatherView, 25)
    .topSpaceToView(newsCover, 10)
    .widthIs(60)
    .heightIs(18)
    ;
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setImage:UIImageNamed(@"publish_share") forState:UIControlStateNormal];
    share.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    comment.sd_layout
    .centerXEqualToView(fatherView)
    .topSpaceToView(newsCover, 10)
    .widthIs(60)
    .heightIs(18)
    ;
//    [comment setTitle:@"1" forState:UIControlStateNormal];
    [comment setImage:UIImageNamed(@"publish_comment") forState:UIControlStateNormal];
    comment.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    praise.sd_layout
    .rightSpaceToView(fatherView, 25)
    .topSpaceToView(newsCover, 10)
    .widthIs(60)
    .heightIs(18)
    ;
//    [praise setTitle:@"1" forState:UIControlStateNormal];
    [praise setImage:UIImageNamed(@"publish_praise") forState:UIControlStateNormal];
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

-(void)setModel:(ArticleModel *)model
{
    _model = model;
    
    [self tapViews];
    UserModel *user = [UserModel getLocalUserModel];
    if (user) {
        [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(user.avatar)) placeholderImage:UIImageNamed(@"loading_placeholder_w")];
    }
    username.text = GetSaveString(model.username);
    creatTime.text = GetSaveString(model.createTime);
    viewCount.text = [NSString stringWithFormat:@"%ld\n阅读",model.viewCount];
    newTitle.text = GetSaveString(model.itemTitle);
    if (model.images.count>0) {
        [newsCover sd_setImageWithURL:UrlWithStr(GetSaveString(model.images[0])) placeholderImage:UIImageNamed(@"placeholder_logo_big")];
    }
    [comment setNormalTitle:[NSString stringWithFormat:@"%ld",model.commentCount]];
    
    [praise setNormalTitle:[NSString stringWithFormat:@"%ld",model.praiseCount]];
}

-(void)tapViews
{
    @weakify(self)
//    [avatar whenTap:^{
//        @strongify(self)
//        if (self.avatarClick) {
//            self.avatarClick();
//        }
//    }];
    
//    [newsCover whenTap:^{
//        @strongify(self)
//        if (self.newsClick) {
//            self.newsClick();
//        }
//    }];
    
    [share whenTap:^{
        @strongify(self)
        if (self.shareClick) {
            self.shareClick();
        }
    }];
    
    [popView whenTap:^{
        @strongify(self)
        if (self.moreClick) {
            self.moreClick();
        }
    }];
}


@end
