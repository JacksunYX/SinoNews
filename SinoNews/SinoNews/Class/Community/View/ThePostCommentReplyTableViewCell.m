//
//  ThePostCommentReplyTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/14.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostCommentReplyTableViewCell.h"

NSString * const ThePostCommentReplyTableViewCellID = @"ThePostCommentReplyTableViewCellID";

@interface ThePostCommentReplyTableViewCell ()
{
    UIImageView *avatar;
    UILabel *nickName;
    UILabel *Landlord;  //楼主标签
    YXLabel *content;
    
    UIButton *praise;   //点赞
    
    UIView *fatherCommentBackView;
    UILabel *fatherComment; //父级评论
    
    UIImageView *leftImg;
    UIImageView *centerImg;
    UIImageView *rightImg;
    UILabel *publishTime;   //发布时间
}
@end

@implementation ThePostCommentReplyTableViewCell

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
    
    nickName = [UILabel new];
    nickName.textColor = HexColor(#161A24);
    nickName.font = PFFontR(15);
    
    praise = [UIButton new];
    [praise setNormalTitleColor:HexColor(#1282EE)];
    praise.titleLabel.font = PFFontR(14);
    
    Landlord = [UILabel new];
    Landlord.textColor = HexColor(#1282EE);
    Landlord.font = PFFontL(10);
    Landlord.textAlignment = NSTextAlignmentCenter;
    
    //父级评论
    fatherCommentBackView = [UIView new];
    fatherComment = [UILabel new];
    fatherComment.textColor = HexColor(#ABB2C3);
    fatherComment.font = PFFontR(15);
    fatherComment.isAttributedContent = YES;
    
    content = [YXLabel new];
    content.textColor = HexColor(#161A24);
    content.font = PFFontL(15);
    content.numberOfLines = 0;
    
    leftImg = [UIImageView new];
    centerImg = [UIImageView new];
    rightImg = [UIImageView new];
    
    publishTime = [UILabel new];
    publishTime.textColor = HexColor(#898989);
    publishTime.font = PFFontL(11);
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 nickName,
                                 praise,
                                 Landlord,
                                 fatherCommentBackView,
                                 
                                 content,
                                 leftImg,
                                 centerImg,
                                 rightImg,
                                 publishTime,
                                 
                                 ]];
    avatar.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .widthIs(28)
    .heightEqualToWidth()
    ;
    avatar.sd_cornerRadius = @14;
    avatar.backgroundColor = Arc4randomColor;
    
    nickName.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 6)
    .heightIs(16)
    ;
    [nickName setSingleLineAutoResizeWithMaxWidth:200];
    
    praise.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    [praise setNormalImage:UIImageNamed(@"company_unPraise")];
    [praise setSelectedImage:UIImageNamed(@"company_praised")];
    
    Landlord.sd_layout
    .centerYEqualToView(nickName)
    .leftSpaceToView(nickName, 8)
    .widthIs(25)
    .heightIs(15)
    ;
    Landlord.sd_cornerRadius = @2;
    Landlord.layer.borderColor = HexColor(#1282EE).CGColor;
    Landlord.layer.borderWidth = 1.0f;
    Landlord.text = @"楼主";
    
    fatherCommentBackView.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(nickName, 12)
    .rightSpaceToView(fatherView, 10)
    ;
    fatherCommentBackView.backgroundColor = HexColor(#F3F3F3);
    
    [fatherCommentBackView addSubview:fatherComment];
    fatherComment.sd_layout
    .topSpaceToView(fatherCommentBackView, 0)
    .leftSpaceToView(fatherCommentBackView, 10)
    .rightSpaceToView(fatherCommentBackView, 13)
    .autoHeightRatio(0)
    ;
    [fatherComment setMaxNumberOfLinesToShow:2];
    
    [fatherCommentBackView setupAutoHeightWithBottomView:fatherComment bottomMargin:0];
    
    content.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(fatherCommentBackView, 10)
    .rightSpaceToView(fatherView, 16)
//    .autoHeightRatio(0)
    .heightIs(0)
    ;
    
    CGFloat imgW = (ScreenW - 30 - 45)/3;
    //    CGFloat imgH = imgW*67/112;
    leftImg.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(content, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    centerImg.sd_layout
    .topEqualToView(leftImg)
    .leftSpaceToView(leftImg, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    rightImg.sd_layout
    .topEqualToView(leftImg)
    .leftSpaceToView(centerImg, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    
    publishTime.sd_layout
    .topSpaceToView(leftImg, 20)
    .leftEqualToView(nickName)
    .heightIs(12)
    ;
    [publishTime setSingleLineAutoResizeWithMaxWidth:100];
    
    [self setupAutoHeightWithBottomView:publishTime bottomMargin:15];
}

-(void)setModel:(PostReplyModel *)model
{
    _model = model;
    @weakify(self);
    
    CGFloat haveFatherComment = 0;
    if (model.postComment) {//回复
        
        NSString *fatherUser = GetSaveString(model.parentCommentAuthor);
        NSString *fatherString = [NSString stringWithFormat:@"：%@",GetSaveString(model.parentComment)];
        NSMutableAttributedString *appendStr = [NSString leadString:fatherUser tailString:fatherString font:PFFontL(15) color:HexColor(#161A24) lineBreak:NO];
        fatherComment.attributedText = appendStr;
        
        haveFatherComment = 7;
    }else{//评论
        fatherComment.attributedText = nil;
    }
    
    fatherComment.sd_layout
    .topSpaceToView(fatherCommentBackView, haveFatherComment)
    ;
    [fatherCommentBackView setupAutoHeightWithBottomView:fatherComment bottomMargin:haveFatherComment];
    
    [avatar sd_setImageWithURL:UrlWithStr(model.avatar)];
    [avatar whenTap:^{
        @strongify(self);
        if (self.avatarBlock) {
            self.avatarBlock(self.tag);
        }
    }];
    
    nickName.text = GetSaveString(model.username);
    
    praise.selected = model.praise;
    NSString *count = @"";
    if (model.likeNum) {
        count = [NSString stringWithFormat:@"%ld",model.likeNum];
    }
    if (praise.selected) {
        [praise setSelectedTitle:count];
    }else{
        [praise setNormalTitle:count];
    }
    
    [praise whenTap:^{
        @strongify(self);
        
        if (self.praiseBlock) {
            self.praiseBlock(self.tag);
        }
    }];
    
    content.text = GetSaveString(model.comment);
    CGFloat height = [content getLabelWithLineSpace:3 width:ScreenW - 44 - 16];
    
    content.sd_layout
    .heightIs(height)
    ;
    [content updateLayout];
    
    publishTime.text = GetSaveString(model.createTime);
    Landlord.hidden = !model.isAuthor;
    
    NSInteger type = 0;
    if (model.postImages.count>0) {
        type = 3;
        if (model.postImages.count<=3){
            type = model.postImages.count;
        }
    }
    CGFloat imgW = (ScreenW - 30 - 45)/3;
    CGFloat imgH = imgW*67/112;
    CGFloat h = 0;
    CGFloat h2 = 0;
    
    //一张图片
    if (type==1) {
        imgW = 234;
        h = 97;
    }else if (type==2||type==3) {
        h = imgH;
        h2 = imgH;
    }
    
    leftImg.sd_layout
    .widthIs(imgW)
    .heightIs(h)
    ;
    centerImg.sd_layout
    .heightIs(h2)
    ;
    rightImg.sd_layout
    .heightIs(h2)
    ;
    if (type >= 1) {
        [leftImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.postImages[0]))];
    }
    if (type >= 2){
        [centerImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.postImages[1]))];
    }
    if (type >= 3){
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.postImages[2]))];
    }
    
}


@end
