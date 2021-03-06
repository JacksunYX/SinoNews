//
//  HomePageThirdKindCell.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageThirdKindCell.h"

@interface HomePageThirdKindCell ()
{
    UILabel *title;
    UIImageView *img;
    UILabel *bottomLabel;
}
@end

@implementation HomePageThirdKindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
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
    title = [UILabel new];
    title.font = NewsTitleFont;
//    title.textColor = HexColor(#323232);
    [title addTitleColorTheme];
    
    img = [UIImageView new];
    img.userInteractionEnabled = YES;
//    img.backgroundColor = Arc4randomColor;
    
    UILabel *label1 = [UILabel new];
    label1.font = FontScale(11);
    label1.textColor = HexColor(#1282EE);
    label1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label2 = [UILabel new];
    label2.font = FontScale(11);
    label2.textColor = HexColor(#1282EE);
    label2.textAlignment = NSTextAlignmentCenter;
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(11);
    [bottomLabel addTitleColorTheme];
//    bottomLabel.textColor = HexColor(#1282EE);
    
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
                                       img,
                                       label1,
//                                       label2,
                                       bottomLabel,
                                       sepLine,
                                       ]];
    
    CGFloat lrMargin = 10;  //左右间距
    CGFloat tbMargin = 10;  //上下间距
    
    //布局
    title.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(self.contentView, tbMargin)
    .rightSpaceToView(self.contentView, lrMargin)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    
    CGFloat imgW = (ScreenW - lrMargin*2);
    CGFloat imgH = imgW * 160.0 / 355;
    img.sd_layout
    .topSpaceToView(title, tbMargin)
    .leftSpaceToView(self.contentView, lrMargin)
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [img  setSd_cornerRadius:@4];
    
    label1.sd_layout
    .rightSpaceToView(self.contentView, lrMargin)
    .topSpaceToView(img, tbMargin)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 11 * 3)
    ;
    LRViewBorderRadius(label1, 2, 1, HexColor(#1282EE));
    label1.text = @"广告";
    
    label2.sd_layout
    .leftSpaceToView(label1, lrMargin)
    .centerYEqualToView(label1)
    .heightIs(ScaleW * 16)
    .widthIs(ScaleW * 11 * 5)
    ;
    LRViewBorderRadius(label2, 2, 1, HexColor(#1282EE));
    label2.text = @"立即下载";
    
    bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, lrMargin)
    .centerYEqualToView(label1)
    .heightIs(ScaleW * 16)
    ;
    [bottomLabel setSingleLineAutoResizeWithMaxWidth:250];
    
    sepLine.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:label1 bottomMargin:tbMargin];
}

-(void)setType:(NSInteger)type
{
    _type = type;
    
}

-(void)setModel:(ADModel *)model
{
    _model = model;
    NSString *titletext = GetSaveString(model.itemTitle);
    if ([titletext containsString:@"<font"]) {
        title.attributedText = [NSString analysisHtmlString:titletext];
        //⚠️字体需要在这里重新设置才行，不然会变小
        title.font = NewsTitleFont;
    }else{
        title.text = titletext;
    }
    [title updateLayout];
    [img sd_setImageWithURL:UrlWithStr(GetSaveString(model.url))];
    
    CGFloat lrMargin = 10;  //左右间距
    CGFloat imgW = (ScreenW - lrMargin*2);
    CGFloat imgH = imgW * 160.0 / 355;
    bottomLabel.text = @"";
    if (self.type == 1) {
        imgH = imgW * 80.0 / 355;
        bottomLabel.text = GetSaveString(self.model.name);
    }
    img.sd_layout
    .widthIs(imgW)
    .heightIs(imgH)
    ;
    [img  setSd_cornerRadius:@4];
}








@end
