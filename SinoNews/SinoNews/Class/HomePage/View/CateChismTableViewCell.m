//
//  CateChismTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CateChismTableViewCell.h"
@interface CateChismTableViewCell ()
{
    UIImageView *avatar;
    UILabel *username;
    UIButton *praise;   //点赞
    UILabel *content;   //内容
    UIImageView *imgL;
    UIImageView *imgC;
    UIImageView *imgR;
    UILabel *bottomLabel;
    UILabel *typeLabel;
}
@end

@implementation CateChismTableViewCell

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
    
    avatar = [UIImageView new];
    avatar.backgroundColor = Arc4randomColor;
    
    username = [UILabel new];
    username.font = PFFontR(12);
    username.lee_theme.LeeConfigTextColor(@"titleColor");
    
    praise = [UIButton new];
    [praise setNormalTitleColor:HexColor(#929697)];
    praise.titleLabel.font = PFFontL(12);
    
    content = [UILabel new];
    content.textColor = HexColor(#323232);
    content.font = PFFontL(15);
    
    imgL = [UIImageView new];
    imgL.userInteractionEnabled = YES;
    imgL.backgroundColor = Arc4randomColor;
    imgC = [UIImageView new];
    imgC.userInteractionEnabled = YES;
    imgC.backgroundColor = Arc4randomColor;
    imgR = [UIImageView new];
    imgR.userInteractionEnabled = YES;
    imgR.backgroundColor = Arc4randomColor;
    
    [self.contentView sd_addSubviews:@[
                                       avatar,
                                       username,
                                       content,
                                       praise,
                                       
                                       imgL,
                                       imgC,
                                       imgR,
                                       
                                       ]];
    avatar.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(28)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@14];
    
    username.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 10)
    .heightIs(12)
    ;
    [username setSingleLineAutoResizeWithMaxWidth:80];
    username.text = @"╰☆叶枫〆";
    
    praise.sd_layout
    .rightSpaceToView(self.contentView, 20)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
    //    praise.backgroundColor = Arc4randomColor;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [praise setNormalImage:UIImageNamed(@"company_unPraise")];
    [praise setSelectedImage:UIImageNamed(@"company_unPraise")];
    
    content.sd_layout
    .leftEqualToView(avatar)
    .topSpaceToView(avatar, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
    //最多显示5行
    [content setMaxNumberOfLinesToShow:5];
    content.text = @"法国本场排出4231阵型，吉鲁单箭头，姆巴佩、格列兹曼和马图伊迪身后埋伏，博格巴和坎特双后腰。后卫线上，瓦拉内和乌姆蒂蒂搭档中卫，埃尔南德斯和帕瓦尔一左一右，门将还是洛里斯。曼朱基雷比奇和佩里西奇两翼齐飞，立即底气、莫德里奇和部落立即底气、莫德里奇和部落立即底气、莫德里奇和部落立即底气、莫德里奇和部落";
    
    [self setupAutoHeightWithBottomView:imgL bottomMargin:10];
}

-(void)setImageType:(NSInteger)imageType
{
    _imageType = imageType;
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lrMargin = 10;  //左右间距
    CGFloat imgMargin = 5;  //图片间距
    CGFloat tbMargin = 0;  //上下间距
    CGFloat imgWL = 0;
    CGFloat imgWC = 0;
    CGFloat imgWR = 0;
    if (self.imageType != 0) {
        tbMargin = 10;
    }
    switch (self.imageType) {
        case 1:
        {
            imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
        }
            break;
        case 2:
        {
            imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
            imgWC = imgWL;
        }
            break;
        case 3:
        {
            imgWL = (ScreenW - lrMargin*2 - imgMargin*2)/3;
            imgWC = imgWL;
            imgWR = imgWL;
        }
            break;
            
        default:
            break;
    }
    
    imgL.sd_layout
    .topSpaceToView(content, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgWL)
    .heightEqualToWidth()
    ;
    [imgL setSd_cornerRadius:@4];
    
    imgC.sd_layout
    .topEqualToView(imgL)
    .leftSpaceToView(imgL, imgMargin)
    .widthIs(imgWC)
    .heightEqualToWidth()
    ;
    [imgC setSd_cornerRadius:@4];
    
    imgR.sd_layout
    .topEqualToView(imgC)
    .leftSpaceToView(imgC, imgMargin)
    .widthIs(imgWR)
    .heightEqualToWidth()
    ;
    [imgR setSd_cornerRadius:@4];
    
}


@end
