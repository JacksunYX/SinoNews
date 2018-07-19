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
    
    praise = [UIButton new];
    [praise setTitleColor:RGBA(152, 152, 152, 1) forState:UIControlStateNormal];
    praise.titleLabel.font = PFFontR(14);
    
    username = [UILabel new];
    username.font = PFFontR(14);
    [username addTitleColorTheme];
    
    comment = [UILabel new];
    comment.font = PFFontL(14);
    comment.numberOfLines = 0;
    [comment addContentColorTheme];
    
    createTime = [UILabel new];
    createTime.font = PFFontL(11);
    createTime.textColor = RGBA(137, 137, 137, 1);
    
    replyBtn = [UIButton new];
    replyBtn.titleLabel.font = PFFontR(11);
    [replyBtn setTitleColor:RGBA(137, 137, 137, 1) forState:UIControlStateNormal];
    
    bottomBackView = [UIView new];
//    bottomBackView.backgroundColor = RGBA(243, 243, 243, 1);
    [bottomBackView addBakcgroundColorTheme];
    
    UIView *fatherView = self.contentView;
    @weakify(self);
    
    [fatherView sd_addSubviews:@[
                                 avatar,
                                 praise,
                                 username,
                                 comment,
                                 createTime,
                                 replyBtn,
                                 bottomBackView,
                                 ]];
    
    avatar.sd_layout
    .topSpaceToView(fatherView, 4)
    .leftSpaceToView(fatherView, 9)
    .widthIs(24)
    .heightEqualToWidth()
    ;
    [avatar setSd_cornerRadius:@12];
    avatar.backgroundColor = Arc4randomColor;
    
    praise.sd_layout
    .rightSpaceToView(fatherView, 20)
    .centerYEqualToView(avatar)
    .widthIs(60)
    .heightIs(20)
    ;
//    praise.backgroundColor = Arc4randomColor;
    praise.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -50);
    praise.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [praise setNormalImage:UIImageNamed(@"company_unPraise")];
    [praise setSelectedImage:UIImageNamed(@"company_praised")];
    
    username.sd_layout
    .centerYEqualToView(avatar)
    .leftSpaceToView(avatar, 4)
    .heightIs(14)
    .rightSpaceToView(praise, 20)
    ;
    
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
    [createTime setSingleLineAutoResizeWithMaxWidth:50];
    
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
    checkAllReplayLabel.font = PFFontR(11);
    checkAllReplayLabel.textColor = RGBA(152, 152, 152, 1);
    checkAllReplayLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        if (self.checkAllReplay) {
            self.checkAllReplay(self.tag);
        }
    }];
    [checkAllReplayLabel addGestureRecognizer:tap];
    
    first = [UILabel new];
    first.isAttributedContent = YES;
    first.font = PFFontR(14);
    [first addContentColorTheme];
    first.userInteractionEnabled = YES;
    
    second = [UILabel new];
    second.isAttributedContent = YES;
    second.font = PFFontR(14);
    [second addContentColorTheme];
    second.userInteractionEnabled = YES;
    
    checkImg = [UIImageView new];
    
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
    .widthIs(8)
    .heightEqualToWidth()
    ;
    checkImg.image = UIImageNamed(@"company_checkAllReplay");
    
    [bottomBackView setupAutoHeightWithBottomView:checkAllReplayLabel bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:bottomBackView bottomMargin:10];
}

-(void)setModel:(CompanyCommentModel *)model
{
    _model = model;
    @weakify(self);
    
//    NSString *avaterStr = [NSString stringWithFormat:@"%@%@",defaultUrl,GetSaveString(model.avatar)];
    [avatar sd_setImageWithURL:UrlWithStr(GetSaveString(model.avatar))];
    
    username.text = GetSaveString(model.username);
    
    comment.text = GetSaveString(model.comment);
    
    praise.selected = model.isPraise;
    NSString *count = [NSString stringWithFormat:@"%ld",model.likeNum];
    if (praise.selected) {
        [praise setNormalTitle:count];
    }else{
        [praise setSelectedTitle:count];
    }
    
    [[praise rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
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
    
    createTime.text = @"1小时前";
    
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
    [bottomBackView addGestureRecognizer:tapB];
}





@end
