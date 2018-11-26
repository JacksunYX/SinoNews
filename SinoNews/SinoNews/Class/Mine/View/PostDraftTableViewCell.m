//
//  PostDraftTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/31.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "PostDraftTableViewCell.h"

NSString *const PostDraftTableViewCellID = @"PostDraftTableViewCellID";

@interface PostDraftTableViewCell ()
{
    UILabel *title;
    UIImageView *leftImg;
    UIImageView *centerImg;
    UIImageView *rightImg;
    UILabel *saveTime;
}
@end

@implementation PostDraftTableViewCell

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
    title = [UILabel new];
    title.font = PFFontL(15);
//    title.textColor = HexColor(#161A24);
    [title addTitleColorTheme];
    
    leftImg = [UIImageView new];
    centerImg = [UIImageView new];
    rightImg = [UIImageView new];
    
    saveTime = [UILabel new];
    saveTime.font = PFFontL(11);
    saveTime.textColor = HexColor(#989898);
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 title,
                                 leftImg,
                                 centerImg,
                                 rightImg,
                                 saveTime,
                                 ]];
    title.sd_layout
    .topSpaceToView(fatherView, 15)
    .leftSpaceToView(fatherView, 10)
    .rightSpaceToView(fatherView, 15)
    .autoHeightRatio(0)
    ;
    
    CGFloat imgW = (ScreenW - 40)/3;
//    CGFloat imgH = imgW*67/112;
    leftImg.sd_layout
    .topSpaceToView(title, 5)
    .leftSpaceToView(fatherView, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    centerImg.sd_layout
    .topSpaceToView(title, 5)
    .leftSpaceToView(leftImg, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    rightImg.sd_layout
    .topSpaceToView(title, 5)
    .leftSpaceToView(centerImg, 10)
    .widthIs(imgW)
    .heightIs(0)
    ;
    
    saveTime.sd_layout
    .rightSpaceToView(fatherView, 10)
    .topSpaceToView(leftImg, 5)
    .heightIs(12)
    ;
    [saveTime setSingleLineAutoResizeWithMaxWidth:150];
    
    
    leftImg.sd_cornerRadius = @3;
    centerImg.sd_cornerRadius = @3;
    rightImg.sd_cornerRadius = @3;
    [self setupAutoHeightWithBottomView:saveTime bottomMargin:10];
}

-(void)setData:(NSDictionary *)data
{
    NSInteger type = [data[@"imgs"] integerValue];
    CGFloat imgW = (ScreenW - 40)/3;
    CGFloat imgH = imgW*67/112;
    CGFloat h = 0;
    CGFloat h2 = 0;
    if (type!=0) {
        h = imgH;
        if (type==3) {
            h2 = imgH;
        }
    }
    leftImg.sd_layout
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

-(void)setDraftModel:(SeniorPostDataModel *)draftModel
{
    _draftModel = draftModel;
    
    NSInteger type = 0;
    if (draftModel.images.count>0) {
        if (draftModel.images.count<=3){
            type = draftModel.images.count;
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
        [leftImg sd_setImageWithURL:UrlWithStr(GetSaveString(draftModel.images[0]))];
    }
    if (type >= 2){
        [centerImg sd_setImageWithURL:UrlWithStr(GetSaveString(draftModel.images[1]))];
    }
    if (type >= 3){
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(draftModel.images[2]))];
    }
    
    if ([NSString isEmpty:draftModel.postTitle]) {
        if (draftModel.postContent.length>10) {
            title.text = [NSString stringWithFormat:@"%@...",[draftModel.postContent substringToIndex:9]];
        }else{
            title.text = GetSaveString(draftModel.postContent);
        }
    }else{
        title.text = GetSaveString(draftModel.postTitle);
    }
    
    saveTime.text = [NSString getTimeDifferenceWith:draftModel.saveTime];
}

@end
