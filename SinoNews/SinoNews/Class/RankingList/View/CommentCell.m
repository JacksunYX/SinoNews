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
    UILabel *checkAllReplay;
    
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
    
    comment = [UILabel new];
    comment.font = PFFontL(14);
    comment.numberOfLines = 0;
    
    createTime = [UILabel new];
    createTime.font = PFFontL(11);
    createTime.textColor = RGBA(137, 137, 137, 1);
    
    replyBtn = [UIButton new];
    replyBtn.titleLabel.font = PFFontR(11);
    [replyBtn setTitleColor:RGBA(137, 137, 137, 1) forState:UIControlStateNormal];
    
    bottomBackView = [UIView new];
    bottomBackView.backgroundColor = RGBA(243, 243, 243, 1);
    
    UIView *fatherView = self.contentView;
    
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
    
    checkAllReplay = [UILabel new];
    checkAllReplay.font = PFFontR(11);
    checkAllReplay.textColor = RGBA(152, 152, 152, 1);
    
    first = [UILabel new];
    first.isAttributedContent = YES;
    first.font = PFFontR(14);
    
    second = [UILabel new];
    second.isAttributedContent = YES;
    second.font = PFFontR(14);
    
    [bottomBackView sd_addSubviews:@[
                                     checkAllReplay,
                                     first,
                                     second,
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
    
    checkAllReplay.sd_layout
    .leftSpaceToView(bottomBackView, 10)
    .topSpaceToView(second, 0)
    .rightSpaceToView(bottomBackView, 10)
    .heightIs(0)
    ;
//    checkAllReplay.backgroundColor = Arc4randomColor;
    
    [bottomBackView setupAutoHeightWithBottomView:checkAllReplay bottomMargin:0];
    
    [self setupAutoHeightWithBottomView:bottomBackView bottomMargin:10];
}

-(void)setModel:(CompanyCommentModel *)model
{
    _model = model;
    NSString *avaterStr = [NSString stringWithFormat:@"%@%@",defaultUrl,GetSaveString(model.avatar)];
    [avatar sd_setImageWithURL:UrlWithStr(avaterStr)];
    
    [praise setImage:UIImageNamed(@"company_unPraise") forState:UIControlStateNormal];
    
    username.text = GetSaveString(model.username);
    
    comment.text = GetSaveString(model.comment);
    
    [praise setTitle:@"23" forState:UIControlStateNormal];
    
    createTime.text = @"1小时前";
    
    checkAllReplay.text = [NSString stringWithFormat:@"查看全部%@条评论",model.replyNum];
    
    CGFloat marginT = 0;
    CGFloat marginM = 0;
    CGFloat marginB = 0;
    CGFloat checkBtnH = 0;
    
    if (model.replyList.count > 0) {
        CompanyCommentModel *replaymodel1 = model.replyList[0];
        NSMutableAttributedString *arrstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",replaymodel1.username,replaymodel1.comment]];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontL(14),
                              };
        [arrstr addAttributes:dic range:NSMakeRange(arrstr.length - replaymodel1.comment.length, replaymodel1.comment.length)];
        first.attributedText = arrstr;
        marginT = 7;
        marginB = 9;
        checkBtnH = 11;
    }
    if (model.replyList.count > 1) {
        CompanyCommentModel *replaymodel2 = model.replyList[1];
        NSMutableAttributedString *arrstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：%@",replaymodel2.username,replaymodel2.comment]];
        NSDictionary *dic = @{
                              NSFontAttributeName : PFFontL(14),
                              };
        [arrstr addAttributes:dic range:NSMakeRange(arrstr.length - replaymodel2.comment.length, replaymodel2.comment.length)];
        second.attributedText = arrstr;
        marginM = 5;
    }
    
    first.sd_layout
    .topSpaceToView(bottomBackView, marginT)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    second.sd_layout
    .topSpaceToView(first, marginM)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .autoHeightRatio(0)
    ;
    checkAllReplay.sd_layout
    .topSpaceToView(second, marginB)
    .leftSpaceToView(bottomBackView, 10)
    .rightSpaceToView(bottomBackView, 10)
    .heightIs(checkBtnH)
    ;
    [bottomBackView setupAutoHeightWithBottomView:checkAllReplay bottomMargin:marginB];
}



@end
