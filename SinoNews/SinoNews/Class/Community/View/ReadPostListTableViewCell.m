//
//  ReadPostListTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/11/1.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ReadPostListTableViewCell.h"

NSString * _Nullable const ReadPostListTableViewCellID = @"ReadPostListTableViewCellID";

@interface ReadPostListTableViewCell ()
{
    UIImageView *avatar;
    UILabel *nickName;
    UILabel *title;
    UILabel *channel;       //所属频道
    
    UIImageView *leftImg;
    UIImageView *centerImg;
    UIImageView *rightImg;
    UILabel *publishTime;   //发布时间
    UILabel *comments;      //评论数
    
    UIView *bottomView;     //最新评论视图
    UILabel *childCommentUser;  //子评论所属发布者
    UILabel *childComment;  //子评论
}
@end

@implementation ReadPostListTableViewCell

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
    
    nickName = [UILabel new];
    nickName.textColor = HexColor(#161A24);
    nickName.font = PFFontR(15);
    title = [UILabel new];
    title.textColor = HexColor(#1A1A1A);
    title.font = PFFontL(15);
    channel = [UILabel new];
    channel.textColor = HexColor(#ABB2C3);
    channel.font = PFFontL(11);
    
    leftImg = [UIImageView new];
    centerImg = [UIImageView new];
    rightImg = [UIImageView new];
    
    publishTime = [UILabel new];
    publishTime.textColor = HexColor(#898989);
    publishTime.font = PFFontL(11);
    comments = [UILabel new];
    comments.textColor = HexColor(#ABB2C3);
    comments.font = PFFontL(11);
    
    bottomView = [UIView new];
    
    childCommentUser = [UILabel new];
    childCommentUser.font = PFFontR(15);
    childCommentUser.textColor = HexColor(#161A24);
    childComment = [UILabel new];
    childComment.font = PFFontL(14);
    childComment.textColor = HexColor(#161A24);
    
    [self.contentView sd_addSubviews:@[
                                       avatar,
                                       nickName,
                                       title,
                                       channel,
                                       leftImg,
                                       centerImg,
                                       rightImg,
                                       publishTime,
                                       comments,
                                       bottomView,
                                       
                                       ]];
    [bottomView sd_addSubviews:@[
                                 childCommentUser,
                                 childComment,
                                 
                                 ]];
    [self setUpTopView];
    [self setUpBottomView];
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
}

//设置上半部分视图
-(void)setUpTopView
{
    UIView *fatherView = self.contentView;
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
    nickName.text = @"春风十里";
    
    title.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(nickName, 12)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
    title.text = @"国家统计局公布的数据显示，初步核算，前三季 度国内生产总值650899亿元，按可比价格计算， 同比增长6.7%。";
    
    channel.sd_layout
    .centerYEqualToView(avatar)
    .rightSpaceToView(fatherView, 10)
    .heightIs(12)
    ;
    [channel setSingleLineAutoResizeWithMaxWidth:80];
    
    CGFloat imgW = (ScreenW - 30 - 44)/3;
    //    CGFloat imgH = imgW*67/112;
    leftImg.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(title, 0)
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
    .topSpaceToView(leftImg, 15)
    .leftEqualToView(nickName)
    .heightIs(12)
    ;
    [publishTime setSingleLineAutoResizeWithMaxWidth:50];
    publishTime.text = @"1小时前";
    
    comments.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(publishTime)
    .heightIs(12)
    ;
    [comments setSingleLineAutoResizeWithMaxWidth:50];
    comments.text = @"30评论";
}

//设置下半部分视图
-(void)setUpBottomView
{
    bottomView.sd_layout
    .topSpaceToView(publishTime, 0)
    .leftEqualToView(nickName)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0)
    ;
    bottomView.backgroundColor = HexColor(#F3F3F3);
    
    childCommentUser.sd_layout
    .leftSpaceToView(bottomView, 10)
    .centerYEqualToView(bottomView)
    .heightIs(16)
    ;
    [childCommentUser setSingleLineAutoResizeWithMaxWidth:80];
    
    childComment.sd_layout
    .leftSpaceToView(childCommentUser, 0)
    .centerYEqualToView(childCommentUser)
    .rightSpaceToView(bottomView, 10)
    .heightRatioToView(childCommentUser, 1)
    ;

}

-(void)setData:(NSDictionary *)model
{
    NSInteger type = [model[@"imgs"] integerValue];
    NSInteger showComment = [model[@"ShowChildComment"] integerValue];
    CGFloat imgW = (ScreenW - 30 - 44)/3;
    CGFloat imgH = imgW*60/100;
    CGFloat h = 0;
    CGFloat h2 = 0;
    
    if (type!=0) {
        //说明只有一张图片
        if (type==1) {
            imgW = 234;
            h = 97;
        }else if (type==3) {
            h = imgH;
            h2 = imgH;
        }
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
    
    leftImg.image = UIImageNamed(@"gameAd_0");
    centerImg.image = UIImageNamed(@"gameAd_1");
    rightImg.image = UIImageNamed(@"gameAd_2");
    
    if (showComment) {
        bottomView.sd_layout
        .topSpaceToView(publishTime, 15)
        .heightIs(30)
        ;
        childComment.text = @"：尤为值得关注的是，高新技术投资是亮点。京东金融副总裁、首席经济学家沈建光指出，专用设备制造业、电气机械和器材制造业、计算机";
        childCommentUser.text = @"幻影痴迷者";
    }else{
        bottomView.sd_layout
        .topSpaceToView(publishTime, 0)
        .heightIs(0)
        ;
        childComment.text = @"";
        childCommentUser.text = @"";
    }
}

@end
