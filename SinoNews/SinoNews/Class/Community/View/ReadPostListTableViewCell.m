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
    UILabel *level;
    UIView *idView;
    UILabel *title;
    UILabel *oliver;        //好文
    UILabel *highQuality;   //精品
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

    if (!self.editing) return;
    //替换编辑模式下cell左边的图片
    if (self.isEditing) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //这里自定义了cell 就改变自定义控件的颜色
        //        self.textLabel.backgroundColor = [UIColor clearColor];
        UIControl *control = [self.subviews lastObject];
        UIImageView * imgView = [[control subviews] objectAtIndex:0];
        if (self.isSelected) {
            imgView.image = [UIImage imageNamed:@"collect_selected"];
        }else{
            imgView.image = [UIImage imageNamed:@"collect_unSelected"];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *selectView = [UIView new];
        selectView.backgroundColor = ClearColor;
        self.selectedBackgroundView = selectView;
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{
    avatar = [UIImageView new];
    avatar.contentMode = 2;
    avatar.layer.masksToBounds = YES;
    
    nickName = [UILabel new];
    nickName.textColor = HexColor(#161A24);
    nickName.font = PFFontL(14);
    level = [UILabel new];
    level.font = PFFontM(12);
    level.textAlignment = NSTextAlignmentCenter;
    level.textColor = WhiteColor;
    level.backgroundColor = HexColor(#1282EE);
    idView = [UIView new];
    idView.backgroundColor = ClearColor;
    title = [UILabel new];
    title.textColor = HexColor(#1A1A1A);
    title.font = PFFontR(15);
    
    oliver = [UILabel new];
    oliver.textColor = WhiteColor;
    oliver.font = PFFontL(12);
    oliver.backgroundColor = HexColor(ffb900);
    oliver.textAlignment = NSTextAlignmentCenter;
    
    highQuality = [UILabel new];
    highQuality.textColor = WhiteColor;
    highQuality.font = PFFontL(12);
    highQuality.backgroundColor = HexColor(ff7d05);
    highQuality.textAlignment = NSTextAlignmentCenter;
    
    channel = [UILabel new];
    channel.textColor = HexColor(#ABB2C3);
    channel.font = PFFontL(11);
    
    leftImg = [UIImageView new];
    leftImg.contentMode = UIViewContentModeScaleAspectFill;
    leftImg.clipsToBounds = YES;
    
    centerImg = [UIImageView new];
    centerImg.contentMode = UIViewContentModeScaleAspectFill;
    centerImg.clipsToBounds = YES;
    
    rightImg = [UIImageView new];
    rightImg.contentMode = UIViewContentModeScaleAspectFill;
    rightImg.clipsToBounds = YES;
    
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
                                       level,
                                       idView,
                                       title,
                                       oliver,
                                       highQuality,
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
//    avatar.backgroundColor = Arc4randomColor;
    
    nickName.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 6)
    .heightIs(16)
    ;
    [nickName setSingleLineAutoResizeWithMaxWidth:200];
    
    level.sd_layout
    .leftSpaceToView(nickName, 10)
    .centerYEqualToView(nickName)
    .widthIs(0)
    .heightIs(18)
    ;
    [level setSd_cornerRadius:@9];
    level.hidden = YES;
    
    idView.sd_layout
    .heightIs(20)
    .centerYEqualToView(level)
    .leftSpaceToView(nickName, 10)
    .rightSpaceToView(fatherView, 10)
    ;
    
    title.sd_layout
    .leftSpaceToView(avatar, 6)
    .topSpaceToView(nickName, 12)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
    
    oliver.sd_layout
    .leftSpaceToView(avatar, 6)
    .topSpaceToView(nickName, 15)
    .widthIs(30)
    .heightIs(15)
    ;
    oliver.text = @"好文";
    oliver.sd_cornerRadius = @2;
    
    highQuality.sd_layout
    .leftSpaceToView(oliver, 3)
    .topSpaceToView(nickName, 15)
    .widthIs(18)
    .heightIs(15)
    ;
    highQuality.text = @"精";
    highQuality.sd_cornerRadius = @2;
    
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
    .topSpaceToView(title, 10)
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
    
    leftImg.sd_cornerRadius = @3;
    centerImg.sd_cornerRadius = @3;
    rightImg.sd_cornerRadius = @3;
    
    publishTime.sd_layout
    .topSpaceToView(leftImg, 15)
    .leftEqualToView(nickName)
    .heightIs(12)
    ;
    [publishTime setSingleLineAutoResizeWithMaxWidth:150];
    
    comments.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(publishTime)
    .heightIs(12)
    ;
    [comments setSingleLineAutoResizeWithMaxWidth:150];
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

//设置标签视图
-(void)setIdViewWithIDs
{
    //先清除
    [idView removeAllSubviews];
    if (self.model.identifications.count>0) {
        CGFloat wid = 30;
        CGFloat hei = 30;
        CGFloat spaceX = 0;
        
        UIView *lastView = idView;
        for (int i = 0; i < self.model.identifications.count; i ++) {
            NSDictionary *model = self.model.identifications[i];
            UIImageView *approveView = [UIImageView new];
            [idView addSubview:approveView];
            
            if (i != 0) {
                spaceX = 10;
            }
            approveView.contentMode = 1;
            approveView.sd_layout
            .centerYEqualToView(idView)
            .leftSpaceToView(lastView, spaceX)
            .widthIs(wid)
            .heightIs(hei)
            ;
            //            [approveView setSd_cornerRadius:@(wid/2)];
            [approveView sd_setImageWithURL:UrlWithStr(model[@"avatar"])];
            
            lastView = approveView;
//            if (i == self.model.identifications.count - 1) {
//                [idView setupAutoWidthWithRightView:lastView rightMargin:0];
//            }
        }
    }
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

-(void)setModel:(SeniorPostDataModel *)model
{
    _model = model;
    NSInteger type = 0;
    if (model.images.count>0) {
        type = 3;
        if (model.images.count<=3){
            type = model.images.count;
        }
    }
    CGFloat imgW = (ScreenW - 30 - 44)/3;
    CGFloat imgH = imgW*60/100;
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
        [leftImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.images[0]))];
    }
    if (type >= 2){
        [centerImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.images[1]))];
    }
    if (type >= 3){
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(model.images[2]))];
    }else{
        rightImg.image = nil;
    }
    [avatar sd_setImageWithURL:UrlWithStr(model.avatar)];
    
    NSString *titleStr = GetSaveString(model.postTitle);
    if (model.rate == 1) {  //好文
        titleStr = AppendingString(@"       ", titleStr);
        oliver.hidden = NO;
        highQuality.hidden = YES;
    }else if (model.rate == 2){ //好文加精
        titleStr = AppendingString(@"           ", titleStr);
        oliver.hidden = NO;
        highQuality.hidden = NO;
    }else{
        oliver.hidden = YES;
        highQuality.hidden = YES;
    }
    title.text = titleStr;
    
    if (model.username) {
        nickName.text = GetSaveString(model.username);
    }else{
        nickName.text = GetSaveString(model.author);
    }
//    level.hidden = model.level?NO:YES;
//    level.text = [NSString stringWithFormat:@"Lv.%ld",model.level];
    [self setIdViewWithIDs];
    publishTime.text = GetSaveString(model.createTime);
    //去掉首位空格和换行
    comments.text = [[NSString stringWithFormat:@"%ld评论",model.commentCount] removeSpaceAndNewLine];
}

@end
