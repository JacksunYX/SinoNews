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
    UILabel *content;
    
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
    
    //父级评论
    UIView *fatherCommentBackView = [UIView new];
    fatherComment = [UILabel new];
    fatherComment.textColor = HexColor(#ABB2C3);
    fatherComment.font = PFFontR(15);
    fatherComment.isAttributedContent = YES;
    
    content = [UILabel new];
    content.textColor = HexColor(#161A24);
    content.font = PFFontL(15);
    
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
    nickName.text = @"春风十里";
    
    fatherCommentBackView.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(nickName, 12)
    .rightSpaceToView(fatherView, 10)
    ;
    fatherCommentBackView.backgroundColor = HexColor(#F3F3F3);
    
    [fatherCommentBackView addSubview:fatherComment];
    fatherComment.sd_layout
    .topSpaceToView(fatherCommentBackView, 7)
    .leftSpaceToView(fatherCommentBackView, 10)
    .rightSpaceToView(fatherCommentBackView, 13)
    .autoHeightRatio(0)
    ;
    [fatherComment setMaxNumberOfLinesToShow:2];
    NSString *fatherUser = @"写梦一场";
    NSString *fatherString = @"：尤为值得关注的是，高新技术投资是亮点。京东 金融副总裁、首席经济学家沈建光指出，专用设 备制造业、电气机械和器材制造业、计算机";
    NSMutableAttributedString *appendStr = [NSString leadString:fatherUser tailString:fatherString font:PFFontL(15) color:HexColor(#161A24) lineBreak:NO];
    fatherComment.attributedText = appendStr;
    [fatherCommentBackView setupAutoHeightWithBottomView:fatherComment bottomMargin:7];
    
    content.sd_layout
    .leftEqualToView(nickName)
    .topSpaceToView(fatherCommentBackView, 10)
    .rightSpaceToView(fatherView, 16)
    .autoHeightRatio(0)
    ;
    content.text = @"国家统计局公布的数据显示，初步核算，前三季 度国内生产总值650899亿元，按可比价格计算， 同比增长6.7%。";
    
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
    publishTime.text = @"1小时前";
    
    [self setupAutoHeightWithBottomView:publishTime bottomMargin:15];
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    CGFloat imgW = (ScreenW - 30 - 45)/3;
    CGFloat imgH = imgW*60/100;
    CGFloat h = 0;
    CGFloat h2 = 0;
    NSInteger type = 3;
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
}


@end
