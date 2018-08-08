//
//  OfficialNotifyCell.m
//  SinoNews
//
//  Created by Michael on 2018/7/9.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "OfficialNotifyCell.h"

@interface OfficialNotifyCell ()
{
    UIImageView *userIcon;  //头像
    UIView      *contentBackView;   //内容的背景
    UIImageView *triangleIcon;      //三角形标记
    UILabel     *content;   //内容
    NSInteger   sendType;   //是官方还是本人
    UIView      *timeBackView;  //时间戳背景图
    UILabel     *time;      //时间
}
@end

@implementation OfficialNotifyCell

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
        self.backgroundColor = RGBA(232, 236, 239, 1);
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    time        = [UILabel new];
    time.font   = PFFontL(12);
    time.textAlignment = NSTextAlignmentCenter;
    
    timeBackView = [UIView new];
    
    contentBackView = [UIView new];
    
    triangleIcon = [UIImageView new];
    
    userIcon    = [UIImageView new];
    
    content     = [UILabel new];
    content.font = PFFontL(15);
    
    [self.contentView sd_addSubviews:@[
                                       time,
                                       timeBackView,
                                       triangleIcon,
                                       content,
                                       contentBackView,
                                       userIcon,
                                       ]];
    [self setupAutoHeightWithBottomView:contentBackView bottomMargin:20];
}

- (void)setModel:(OfficialNotifyModel *)model
{
    _model = model;
    
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *fartherView = self.contentView;
    CGFloat timeHeight = 0;
    CGFloat topX = 0;
    if (!kStringIsEmpty(self.model.time)) {
        topX = 5;
        timeHeight = 20;
        time.textColor = WhiteColor;
    }
    
    time.sd_layout
    .centerXEqualToView(fartherView)
    .topSpaceToView(fartherView, topX)
//    .widthIs(75)
    .heightIs(timeHeight)
    ;
    [time setSingleLineAutoResizeWithMaxWidth:200];
    time.text = GetSaveString(self.model.time);
    [time updateLayout];
//    GGLog(@"wid:%.2lf",time.width);
    
    [fartherView insertSubview:timeBackView belowSubview:time];
    timeBackView.sd_layout
    .centerXEqualToView(time)
    .centerYEqualToView(time)
    .heightRatioToView(time, 1).widthRatioToView(time, 1.2)
    ;
    [timeBackView setSd_cornerRadius:@10];
    timeBackView.backgroundColor = RGBA(199, 203, 206, 1);
    
    [fartherView insertSubview:contentBackView belowSubview:content];
    if (self.model.type) {  //本人
        userIcon.sd_layout
        .topSpaceToView(time, 10)
        .rightSpaceToView(fartherView, 10)
        .widthIs(40)
        .heightEqualToWidth()
        ;
        [userIcon updateLayout];
        
        content.textColor = WhiteColor;
        contentBackView.backgroundColor = RGBA(99, 175, 253, 1);
        triangleIcon.image = UIImageNamed(@"notify_blueTriangle");
        
        triangleIcon.sd_layout
        .centerYEqualToView(userIcon)
        .rightSpaceToView(userIcon, 10)
        .widthIs(7)
        .heightIs(10)
        ;
        [triangleIcon updateLayout];
        
        content.sd_layout
        .topSpaceToView(userIcon, -30)
        .rightSpaceToView(triangleIcon, 10)
        .autoHeightRatio(0)
        ;
        [content setSingleLineAutoResizeWithMaxWidth:ScaleWidth(200)];
        content.text = GetSaveString(self.model.content);
        [content updateLayout];
        
        contentBackView.sd_layout
        .topEqualToView(userIcon)
        .rightSpaceToView(triangleIcon, 0)
        .leftSpaceToView(content, -content.width - 15)
        .bottomSpaceToView(content, -content.height - 15)
        ;
        
    }else{  //官方
        userIcon.sd_layout
        .topSpaceToView(time, 10)
        .leftSpaceToView(fartherView, 10)
        .widthIs(40)
        .heightEqualToWidth()
        ;
        [userIcon updateLayout];
        
        content.textColor = BlackColor;
        contentBackView.backgroundColor = WhiteColor;
        triangleIcon.image = UIImageNamed(@"notify_whiteTriangle");
        
        triangleIcon.sd_layout
        .centerYEqualToView(userIcon)
        .leftSpaceToView(userIcon, 10)
        .widthIs(7)
        .heightIs(10)
        ;
        [triangleIcon updateLayout];
        
        content.sd_layout
        .topSpaceToView(userIcon, -30)
        .leftSpaceToView(triangleIcon, 10)
        .autoHeightRatio(0)
        ;
        [content setSingleLineAutoResizeWithMaxWidth:ScaleWidth(200)];
        content.text = GetSaveString(self.model.content);
        [content updateLayout];
        
        contentBackView.sd_layout
        .topEqualToView(userIcon)
        .leftSpaceToView(triangleIcon, 0)
        .rightSpaceToView(content, -content.width - 15)
        .bottomSpaceToView(content, -content.height - 15)
        ;
        
    }
    [userIcon setSd_cornerRadius:@20];
    [contentBackView setSd_cornerRadius:@8];
    [contentBackView updateLayout];
    
//    userIcon.image = UIImageNamed(GetSaveString(self.model.avatar));
    [userIcon sd_setImageWithURL:UrlWithStr(GetSaveString(self.model.avatar))];
}


@end
