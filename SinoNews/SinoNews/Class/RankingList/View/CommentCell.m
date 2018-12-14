//
//  CommentCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/19.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()
{
    UIImageView *avatar;
    UILabel *username;
    UILabel *level;   //等级
    UILabel *comment;
    UILabel *createTime;
    UIButton *praise;   //点赞
    UIButton *replyBtn; //回复按钮
    
    UIView *bottomBackView;
    UILabel *first;
    UILabel *second;
    UILabel *checkAllReplayLabel;
    UIImageView *checkImg;
}
@end

@implementation CommentCell

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
    avatar.contentMode = 2;
    avatar.layer.masksToBounds = YES;
    
    praise = [UIButton new];
 
    [praise setNormalTitleColor:HexColor(#1282EE)];
    praise.titleLabel.font = PFFontR(14);
    
    username = [UILabel new];
    username.font = PFFontR(16);
    [username addTitleColorTheme];
    
    level = [UILabel new];
    level.font = PFFontM(12);
    level.textAlignment = NSTextAlignmentCenter;
    level.textColor = WhiteColor;
    level.backgroundColor = HexColor(#f3c00f);
    
    comment = [UILabel new];
    comment.font = PFFontL(15);
    comment.numberOfLines = 0;
    [comment addTitleColorTheme];
    
    createTime = [UILabel new];
    createTime.font = PFFontL(11);
    createTime.textColor = RGBA(137, 137, 137, 1);
    
    replyBtn = [UIButton new];
    replyBtn.titleLabel.font = PFFontR(11);
    [replyBtn setTitleColor:RGBA(137, 137, 137, 1) forState:UIControlStateNormal];
    
    bottomBackView = [UIView new];
//    bottomBackView.backgroundColor = RGBA(243, 243, 243, 1);
//    [bottomBackView addBakcgroundColorTheme];
    
    UIView *sepLine = [UIView new];
    sepLine.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }else{
            [(UIView *)item setBackgroundColor:CutLineColor];
        }
    });
    
    UIView *fatherView = self.contentView;
    @weakify(self);
    
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 praise,
                                 username,
                                 level,
                                 comment,
                                 createTime,
                                 replyBtn,
                                 bottomBackView,
                                 sepLine,
                                 ]];
    
    avatar.sd_layout
    .topSpaceToView(fatherView, 4)
    .leftSpaceToView(fatherView, 9)
    .widthIs(28)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@14];
//    avatar.backgroundColor = Arc4randomColor;
    
    praise.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
//    praise.backgroundColor = Arc4randomColor;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    [praise setNormalImage:UIImageNamed(@"company_unPraise")];
    [praise setSelectedImage:UIImageNamed(@"company_praised")];
    
    username.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 4)
    .heightIs(14)
//    .rightSpaceToView(praise, 20)
    ;
    [username setSingleLineAutoResizeWithMaxWidth:100];
    
    level.sd_layout
    .leftSpaceToView(username, 10)
    .centerYEqualToView(username)
    .widthIs(40)
    .heightIs(18)
    ;
    [level setSd_cornerRadius:@9];
    level.hidden = YES;
    
    comment.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(username, 12)
    .rightSpaceToView(fatherView, 10)
    .autoHeightRatio(0)
    ;
//    comment.backgroundColor = Arc4randomColor;
    
    createTime.sd_layout
    .leftEqualToView(username)
    .topSpaceToView(comment, 20)
    .heightIs(11)
    ;
    [createTime setSingleLineAutoResizeWithMaxWidth:80];
    
    replyBtn.sd_layout
    .centerYEqualToView(createTime)
    .leftSpaceToView(createTime, 24)
    .widthIs(46)
    .heightIs(18)
    ;
    [replyBtn setSd_cornerRadius:@5];
    replyBtn.layer.borderColor = RGBA(152, 152, 152, 1).CGColor;
    replyBtn.layer.borderWidth = 1;
    [replyBtn setTitle:@"回复 TA" forState:UIControlStateNormal];
    
    bottomBackView.sd_layout
    .leftEqualToView(username)
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(replyBtn, 10)
    ;
    
    checkAllReplayLabel = [UILabel new];
    checkAllReplayLabel.font = PFFontR(12);
    checkAllReplayLabel.textColor = RGBA(152, 152, 152, 1);
//    checkAllReplayLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if (self.checkAllReplay) {
            self.checkAllReplay(self.tag);
        }
    }];
//    [checkAllReplayLabel addGestureRecognizer:tap];
    
    first = [UILabel new];
    first.isAttributedContent = YES;
    first.font = PFFontR(15);
    [first addTitleColorTheme];
//    first.userInteractionEnabled = YES;
    
    second = [UILabel new];
    second.isAttributedContent = YES;
    second.font = PFFontR(15);
    [second addTitleColorTheme];
//    second.userInteractionEnabled = YES;
    
    checkImg = [UIImageView new];
    
    sepLine.sd_layout
    .leftEqualToView(comment)
    .rightSpaceToView(fatherView, 10)
    .bottomEqualToView(fatherView)
    .heightIs(1)
    ;
    
    [bottomBackView sd_addSubviews:@[
                                     first,
                                     second,
                                     checkAllReplayLabel,
                                     checkImg,
                                     ]];
    
    first.sd_layout
    .topSpaceToView(bottomBackView, 0)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    
    second.sd_layout
    .topSpaceToView(first, 0)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    
    checkAllReplayLabel.sd_layout
    .leftSpaceToView(bottomBackView, 10)
    .topSpaceToView(second, 0)
//    .rightSpaceToView(bottomBackView, 10)
    .heightIs(0)
    ;
//    checkAllReplay.backgroundColor = Arc4randomColor;
    
    checkImg.sd_layout
    .leftSpaceToView(checkAllReplayLabel, 10)
    .centerYEqualToView(checkAllReplayLabel)
    .widthIs(11)
    .heightEqualToWidth()
    ;
//    checkImg.image = UIImageNamed(@"company_checkAllReplay");
    checkImg.lee_theme.LeeConfigImage(@"checkAllReplay");
    
    [bottomBackView setupAutoHeightWithBottomView:checkAllReplayLabel bottomMargin:0];
    
    bottomBackView.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:HexColor(#292D30)];
        }else{
            [(UIView *)item setBackgroundColor:RGBA(243, 243, 243, 1)];
        }
    });
    
    [self setupAutoHeightWithBottomView:bottomBackView bottomMargin:10];
}

-(void)setModel:(CompanyCommentModel *)model
{
    _model = model;
    @weakify(self);
    
//    NSString *avaterStr = [NSString stringWithFormat:@"%@%@",defaultUrl,GetSaveString(model.avatar)];
    [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(model.avatar))];
    
    [avatar whenTap:^{
        @strongify(self)
        if (self.avatarBlock) {
            self.avatarBlock(self.tag);
        }
    }];
    
    username.text = GetSaveString(model.username);
    
    level.hidden = model.level?NO:YES;
    level.text = [NSString stringWithFormat:@"Lv.%lu",model.level];
    
    comment.text = GetSaveString(model.comment);
    
    praise.selected = model.isPraise;
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
        
        [self addanimation];
        if (self.praiseBlock) {
            self.praiseBlock(self.tag);
        }
    }];
    
    replyBtn.hidden = YES;
//    [[replyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        if (self.replayBlock) {
//            self.replayBlock(self.tag);
//        }
//    }];
    replyBtn.userInteractionEnabled = NO;
    
    createTime.text = GetSaveString(model.createTime);
    
    checkAllReplayLabel.text = [NSString stringWithFormat:@"查看全部%@条评论",model.replyNum];
    
    //先移除手势
    for (UITapGestureRecognizer *tap in first.gestureRecognizers) {
        [first removeGestureRecognizer:tap];
    }
    for (UITapGestureRecognizer *tap in second.gestureRecognizers) {
        [second removeGestureRecognizer:tap];
    }
    
    CGFloat marginT = 0;
    CGFloat marginM = 0;
    CGFloat marginB = 0;
    CGFloat checkBtnH = 0;
    UIView *finalView = checkAllReplayLabel;

    NSMutableAttributedString *att1;
    NSMutableAttributedString *att2;
    if (model.replyList.count > 0) {
        CompanyCommentModel *replaymodel1 = model.replyList[0];
        att1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",replaymodel1.username,replaymodel1.comment]];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontL(14),
                              };
        [att1 addAttributes:dic range:NSMakeRange(att1.length - replaymodel1.comment.length, replaymodel1.comment.length)];
        
        marginT = 7;
        marginB = 9;
        first.tag = 0;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
        [[tap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if (self.clickReplay) {
                self.clickReplay(self.tag, 0);
            }
        }];
        [first addGestureRecognizer:tap1];
        finalView = first;
    }else{
        att1 = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    first.attributedText = att1;
    
    if (model.replyList.count > 1) {
        CompanyCommentModel *replaymodel2 = model.replyList[1];
        att2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",replaymodel2.username,replaymodel2.comment]];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontL(14),
                              };
        [att2 addAttributes:dic range:NSMakeRange(att2.length - replaymodel2.comment.length, replaymodel2.comment.length)];
        second.attributedText = att2;
        marginM = 5;
        second.tag = 0;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
        [[tap2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            if (self.clickReplay) {
                self.clickReplay(self.tag, 1);
            }
        }];
        [second addGestureRecognizer:tap2];
        finalView = second;
    }else{
        att2 = [[NSMutableAttributedString alloc]initWithString:@""];
    }
    
    first.sd_layout
    .topSpaceToView(bottomBackView, marginT)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    first.attributedText = att1;
    
    second.sd_layout
    .topSpaceToView(first, marginM)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    second.attributedText = att2;
    
    if ([model.replyNum integerValue]) {
        finalView = checkAllReplayLabel;
        checkBtnH = 11;
        checkAllReplayLabel.hidden = NO;
        checkImg.hidden = NO;
    }else{
        checkAllReplayLabel.hidden = YES;
        checkImg.hidden = YES;
    }
    checkAllReplayLabel.sd_layout
    .topSpaceToView(second, marginB)
    .leftSpaceToView(bottomBackView, 10)
    .heightIs(checkBtnH)
    ;
    [checkAllReplayLabel setSingleLineAutoResizeWithMaxWidth:100];
    [bottomBackView setupAutoHeightWithBottomView:finalView bottomMargin:marginB];
    
    UITapGestureRecognizer *tapB = [[UITapGestureRecognizer alloc] init];
    [[tapB rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
    }];
//    [bottomBackView addGestureRecognizer:tapB];
}

//点赞的动画
- (void)addanimation
{
    //放大动画
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.5),@(1.0),@(1.5),@(1.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [praise.layer addAnimation:k forKey:@"SHOW"];
}



@end
