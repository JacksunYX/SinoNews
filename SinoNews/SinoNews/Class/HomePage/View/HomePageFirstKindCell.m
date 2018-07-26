//
//  HomePageFirstKindCell.m
//  SinoNews
//
//  Created by Michael on 2018/5/29.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageFirstKindCell.h"

@interface HomePageFirstKindCell ()
{
    UILabel *title;
    UIImageView *rightImg;
    UILabel *bottomLabel;
    UILabel *typeLabel;
}
@end

@implementation HomePageFirstKindCell

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
        
        UIView *selectView = [UIView new];
        selectView.backgroundColor = ClearColor;
        self.selectedBackgroundView = selectView;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    title = [UILabel new];
    title.font = FontScale(17);
//    title.textColor = HexColor(#323232);
    title.lee_theme.LeeConfigTextColor(@"titleColor");
    //    title.backgroundColor = Arc4randomColor;
    
    rightImg = [UIImageView new];
    rightImg.userInteractionEnabled = YES;
    rightImg.contentMode = 2;
//    rightImg.backgroundColor = Arc4randomColor;
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(11);
    //    bottomLabel.backgroundColor = Arc4randomColor;
    bottomLabel.isAttributedContent = YES;
    
    typeLabel = [UILabel new];
    typeLabel.font = FontScale(11);
    typeLabel.backgroundColor = WhiteColor;
    typeLabel.textColor = HexColor(#1282EE);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIView *sepLine = [UIView new];
    sepLine.backgroundColor = HexColor(#E3E3E3);
    
    [self.contentView sd_addSubviews:@[
                                       rightImg,
                                       title,
                                       bottomLabel,
                                       typeLabel,
                                       sepLine,
                                       ]];
    //布局
    rightImg.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 15)
    //    .widthIs(kScaelW(130))
    //    .heightIs(kScaelW(130)*80/130)
    .widthIs(kScaelW(105))
    .heightEqualToWidth()
    ;
    [rightImg setSd_cornerRadius:@4];
//    [rightImg cornerWithRadius:4];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:3];
    
    bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 10)
    .bottomEqualToView(rightImg)
    .autoHeightRatio(0)
    ;
    [bottomLabel setMaxNumberOfLinesToShow:1];
    
    typeLabel.sd_layout
    .leftEqualToView(title)
//    .topEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 17)
    .widthIs(ScaleW * 17 + 10)
    ;
    [typeLabel setSd_cornerRadius:@2];
//    [typeLabel cornerWithRadius:2];
    //    [typeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    //    [typeLabel updateLayout];
    //    typeLabel.frame = CGRectMake(typeLabel.frame.origin.x, typeLabel.frame.origin.y, typeLabel.frame.size.width + kScaelW(10), typeLabel.frame.size.height + kScaelW(10));
    
    sepLine.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:rightImg bottomMargin:15];
}

-(void)setModel:(HomePageModel *)model
{
    _model = model;

    NSString *titletext;
    typeLabel.layer.borderColor = HexColor(#1282EE).CGColor;
    typeLabel.layer.borderWidth = 1;
    typeLabel.hidden = YES;
    bottomLabel.textColor = HexColor(#989898);
    if (model.itemType < 200) {
        NSString *labelName = GetSaveString(model.labelName);
        if (kStringIsEmpty(labelName)) {
            titletext = GetSaveString(model.itemTitle);
            
        }else{
            typeLabel.hidden = NO;
            titletext = [@"" stringByAppendingString:GetSaveString(model.itemTitle)];
            typeLabel.text = GetSaveString(model.labelName);
            typeLabel.backgroundColor = WhiteColor;
            typeLabel.textColor = HexColor(#1282EE);
        }
        
        NSString *str1 = @"";
        NSString *str2 = [GetSaveString(model.username) stringByAppendingString:@"  "];
        NSString *str3 = [[NSString stringWithFormat:@"%ld",model.viewCount] stringByAppendingString:@" 阅  "];
        NSString *str4 = [[NSString stringWithFormat:@"%ld",model.commentCount] stringByAppendingString:@" 评"];
        
        if (model.viewCount<=0) {
            str3 = @"";
        }else{
            if (model.viewCount/10000) {
                str3 = [[NSString stringWithFormat:@"%.1f",model.viewCount/10000.0] stringByAppendingString:@" 阅  "];
            }else{
                str3 = [[NSString stringWithFormat:@"%ld",model.viewCount] stringByAppendingString:@" 阅  "];
            }
        }
        if (model.commentCount<=0) {
            str4 = @"";
        }else{
            if (model.commentCount/10000) {
                str4 = [[NSString stringWithFormat:@"%.1f",model.commentCount/10000.0] stringByAppendingString:@" 评"];
            }else{
                str4 = [[NSString stringWithFormat:@"%ld",model.commentCount] stringByAppendingString:@" 评"];
            }
        }
        NSString *totalStr = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:totalStr];
        bottomLabel.attributedText = attString;
        
    }else if (model.itemType >=500 && model.itemType < 600){
        typeLabel.text = @"问答";
        typeLabel.backgroundColor = OrangeColor;
        typeLabel.textColor = WhiteColor;
        typeLabel.hidden = NO;
        typeLabel.layer.borderColor = ClearColor.CGColor;
        typeLabel.layer.borderWidth = 0;
        titletext = GetSaveString(model.itemTitle);
        bottomLabel.textColor = HexColor(#1282EE);
        bottomLabel.text = [NSString stringWithFormat:@"%ld 回答",model.commentCount];
    }else{
        typeLabel.text = @"专题";
        typeLabel.backgroundColor = HexColor(#1282EE);
        typeLabel.textColor = WhiteColor;
        typeLabel.hidden = NO;
        titletext = [@"" stringByAppendingString:GetSaveString(model.itemTitle)];
        bottomLabel.text = @"";
    }
    
    if ([titletext containsString:@"<font"]) {
        title.attributedText = [NSString analysisHtmlString:titletext];
        //⚠️字体需要在这里重新设置才行，不然会变小
        title.font = FontScale(17);
        
    }else{
        title.text = titletext;
    }
    
    if (typeLabel.text.length&&typeLabel.hidden == NO) {
        //⚠️如果文本前面有空格，进过h5编码后，空格会消失，需要重新拼接空格
        NSDictionary *dic1 = @{
                               NSForegroundColorAttributeName:HexColor(#1282EE),
                               NSFontAttributeName:FontScale(17),
                               };
        NSMutableAttributedString *spaceStr = [[NSMutableAttributedString alloc]initWithString:@"      " attributes:dic1];
        [spaceStr appendAttributedString:title.attributedText];
        title.attributedText = spaceStr;
    }
    
    
    if (model.images.count>0) {
        NSString *imgStr = [model.images firstObject];
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    }else{
        rightImg.image = nil;
    }
    
    
}


@end
