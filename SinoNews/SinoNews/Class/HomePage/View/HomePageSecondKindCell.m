//
//  HomePageSecondKindCell.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageSecondKindCell.h"

@interface HomePageSecondKindCell ()
{
    UILabel *title;
    UILabel *tlLabel;     //左上标签
    UIImageView *imgL;
    UIImageView *imgC;
    UIImageView *imgR;
    
    UILabel *bottomLabel;
    UILabel *blLabel;     //左下标签
    
}
@end

@implementation HomePageSecondKindCell

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
    CGFloat lrMargin = 10;  //左右间距
    CGFloat imgMargin = 5;  //图片间距
    CGFloat tbMargin = 10;  //上下间距
    
    title = [UILabel new];
    title.font = FontScale(17);
//    title.textColor = HexColor(#323232);
    
    
    tlLabel = [UILabel new];
    tlLabel.font = FontScale(11);
    tlLabel.backgroundColor = HexColor(#1282EE);
    tlLabel.textColor = WhiteColor;
    tlLabel.textAlignment = NSTextAlignmentCenter;
    
    imgL = [UIImageView new];
    imgL.userInteractionEnabled = YES;
    imgL.contentMode = 2;
//    imgL.backgroundColor = Arc4randomColor;
    imgC = [UIImageView new];
    imgC.userInteractionEnabled = YES;
    imgC.contentMode = 2;
//    imgC.backgroundColor = Arc4randomColor;
    imgR = [UIImageView new];
    imgR.userInteractionEnabled = YES;
    imgR.contentMode = 2;
//    imgR.backgroundColor = Arc4randomColor;
    
    blLabel = [UILabel new];
    blLabel.font = FontScale(12);
    blLabel.textColor = HexColor(#1282EE);
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(12);
    
    UIView *sepLine = [UIView new];
    //设置不同环境下的颜色
    sepLine.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UIView *)item setBackgroundColor:CutLineColorNight];
        }else{
            [(UIView *)item setBackgroundColor:CutLineColor];
        }
    });
    
    [self.contentView sd_addSubviews:@[
                                       title,
                                       tlLabel,
                                       imgL,
                                       imgC,
                                       imgR,
                                       blLabel,
                                       bottomLabel,
                                       sepLine,
                                       ]];
    title.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(self.contentView, tbMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .autoHeightRatio(0)
    ;
//    typeLabel.text = @"专题";
    [title setMaxNumberOfLinesToShow:2];
//    title.text = [@"        " stringByAppendingString:@"发改委 ：多个经济体货币纷纷倒在美元魔掌以 后，美元屠刀或正在伸向欧元区"];
    
    tlLabel.sd_layout
    .leftEqualToView(title)
    //    .topEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 16 + 10)
    ;
    //    [typeLabel setSd_cornerRadius:@2];
    [tlLabel cornerWithRadius:2];
    
    //图片宽度
    CGFloat imgW = (ScreenW - lrMargin*2 - imgMargin*2)/3;
//    CGFloat imgH = imgW * 90.0 / 117;
    CGFloat imgH = imgW;
    imgL.sd_layout
    .topSpaceToView(title, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgL setSd_cornerRadius:@4];
//    [imgL cornerWithRadius:4];
    
    imgC.sd_layout
    .topEqualToView(imgL)
    .leftSpaceToView(imgL, imgMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgC setSd_cornerRadius:@4];
//    [imgC cornerWithRadius:4];
    
    imgR.sd_layout
    .topEqualToView(imgC)
    .leftSpaceToView(imgC, imgMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [imgR setSd_cornerRadius:@4];
//    [imgR cornerWithRadius:4];
    
    blLabel.sd_layout
    .topSpaceToView(imgL, tbMargin)
    .leftSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
    [blLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    bottomLabel.sd_layout
    .leftSpaceToView(blLabel, 0)
    .rightSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(imgL, tbMargin)
    .autoHeightRatio(0)
    ;
    [bottomLabel setMaxNumberOfLinesToShow:1];
    
    sepLine.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:10];
    
}

-(void)setModel:(HomePageModel *)model
{
    _model = model;
    
    title.lee_theme.LeeConfigTextColor(@"titleColor");
    
    bottomLabel.textColor = HexColor(#889199);
    
    //判断是否已经浏览过了
    if (model.hasBrows) {
        title.textColor = BrowsNewsTitleColor;
    }
    
    NSString *titletext = titletext = GetSaveString(model.itemTitle);;
    
    NSString *tipName = GetSaveString(model.tipName);
    if ([NSString isEmpty:tipName]) {
        tlLabel.hidden = YES;
        titletext = GetSaveString(model.itemTitle);
    }else{
        tlLabel.hidden = NO;
        [UniversalMethod processLabel:tlLabel top:YES text:tipName];
    }
    
    blLabel.text = @"";
    if (![NSString isEmpty:GetSaveString(model.labelName)]) {
        blLabel.text = AppendingString(GetSaveString(model.labelName), @"  ");
    }
    
    if(model.itemType>=200&&model.itemType<300){
        //专题
        bottomLabel.text = @"";
    }else if (model.itemType >=500 && model.itemType < 600){
        //问答
        bottomLabel.textColor = HexColor(#1282EE);
        bottomLabel.text = [NSString stringWithFormat:@"%ld 回答",model.commentCount];
    }else{
        //其他新闻
        NSString *str1 = AppendingString(GetSaveString(model.username), @"  ");
        NSString *str2 = [UniversalMethod processNumShow:model.viewCount insertString:@"阅"];
        NSString *str3 = [UniversalMethod processNumShow:model.commentCount insertString:@"评"];
        
        NSString *totalStr = [[str1 stringByAppendingString:str2] stringByAppendingString:str3];
        bottomLabel.text = totalStr;
    }
    
    //判断是否包含标签文字
    if ([titletext containsString:@"<font"]) {
        //解析
        title.attributedText = [NSString analysisHtmlString:titletext];
        //⚠️字体需要在这里重新设置才行，不然会变小
        title.font = FontScale(17);
        //判断是否要缩进
        if (tlLabel.hidden == NO) {
            //⚠️如果文本前面有空格，进过h5编码后，空格会消失，需要重新拼接空格
            NSDictionary *dic1 = @{
                                   NSForegroundColorAttributeName:HexColor(#1282EE),
                                   NSFontAttributeName:FontScale(17),
                                   };
            NSMutableAttributedString *spaceStr = [[NSMutableAttributedString alloc]initWithString:@"      " attributes:dic1];
            [spaceStr appendAttributedString:title.attributedText];
            title.attributedText = spaceStr;
        }
    }else{
        if (tlLabel.hidden == NO) {
            titletext = AppendingString(@"      ", titletext);
        }
        title.text = titletext;
    }
    
    if (model.images.count>0) {
        NSString *imgStr = GetSaveString(model.images[0]);
        [imgL sd_setImageWithURL:UrlWithStr(imgStr) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    }else{
        imgL.image = nil;
    }
    
    if (model.images.count>1) {
        NSString *imgStr = GetSaveString(model.images[1]);
        [imgC sd_setImageWithURL:UrlWithStr(imgStr) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    }else{
        imgC.image = nil;
    }
    
    if (model.images.count>2) {
        NSString *imgStr = GetSaveString(model.images[2]);
        [imgR sd_setImageWithURL:UrlWithStr(imgStr) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    }else{
        imgR.image = nil;
    }
    
}







@end
