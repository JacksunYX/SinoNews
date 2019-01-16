//
//  HomePageFourthCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/21.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "HomePageFourthCell.h"

@interface HomePageFourthCell ()
{
    UILabel *tlLabel;       //左上标签
    UILabel *title;
    UILabel *blLabel;       //左下标签
    UILabel *bottomLabel;
    
}
@end

@implementation HomePageFourthCell

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
    title = [UILabel new];
    title.font = NewsTitleFont;
//    title.textColor = HexColor(#323232);
    
    title.isAttributedContent = YES;
    
    tlLabel = [UILabel new];
    tlLabel.font = FontScale(11);
    tlLabel.backgroundColor = WhiteColor;
    tlLabel.textColor = HexColor(#1282EE);
    tlLabel.textAlignment = NSTextAlignmentCenter;
    
    blLabel = [UILabel new];
    blLabel.font = NewsBottomTip;
    blLabel.textColor = HexColor(#1282EE);
    
    bottomLabel = [UILabel new];
    bottomLabel.font = NewsBottomTitle;
    
    UIView *sepLine = [UIView new];
    //设置不同环境下的颜色
    [sepLine addCutLineColor];
    
    [self.contentView sd_addSubviews:@[
                                       title,
                                       tlLabel,
                                       blLabel,
                                       bottomLabel,
                                       sepLine,
                                       ]];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
//    [title setMaxNumberOfLinesToShow:3];
    
    tlLabel.sd_layout
    .leftEqualToView(title)
    //    .topEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 17)
    .widthIs(ScaleW * 17 + 10)
    ;
    [tlLabel  setSd_cornerRadius:@4];
    //    [typeLabel cornerWithRadius:2];
    
    blLabel.sd_layout
    .topSpaceToView(title, 10)
    .leftSpaceToView(self.contentView, 10)
    .heightIs([FontScale(12) pointSize])
    ;
    [blLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    bottomLabel.sd_layout
    .leftSpaceToView(blLabel, 0)
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(title, 10)
    .heightIs([FontScale(12) pointSize])
    ;
    
    sepLine.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomEqualToView(self.contentView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomViewsArray:@[blLabel,bottomLabel] bottomMargin:15];
}

-(void)setModel:(HomePageModel *)model
{
    _model = model;
    
    [title addTitleColorTheme];
    
    bottomLabel.textColor = HexColor(#889199);
    
    //判断是否已经浏览过了
    if (model.hasBrows) {
        title.textColor = BrowsNewsTitleColor;
    }
    
    NSString *titletext = GetSaveString(model.itemTitle);
    
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
    
//    if(model.itemType>=200&&model.itemType<300){
//        //专题
//        bottomLabel.text = @"";
//    }else
    if (model.itemType >=500 && model.itemType < 600){
        //问答
        bottomLabel.textColor = HexColor(#1282EE);
        bottomLabel.text = [NSString stringWithFormat:@"%ld 回答",model.commentCount];
    }else{
        //其他新闻
        NSString *str1 = @"";
        if (self.bottomShowType) {
            
        }else if(model.itemType>=200&&model.itemType<300){
            //专题
            
        }else{
            if (!model.topicId) {
              str1 = AppendingString(GetSaveString(model.username), @"  ");
            }
        }
        NSString *str2 = [UniversalMethod processNumShow:model.viewCount insertString:@"阅"];
        NSString *str3 = [UniversalMethod processNumShow:model.commentCount insertString:@"评"];
        
        NSString *totalStr = [[str1 stringByAppendingString:str2] stringByAppendingString:str3];
        bottomLabel.text = totalStr;
    }
    
    if (self.bottomShowType) {
        bottomLabel.text = [bottomLabel.text stringByAppendingString:GetSaveString(model.createTime)];
    }
    
    //判断是否包含标签文字
    if ([titletext containsString:@"<font"]) {
        //解析
        title.attributedText = [NSString analysisHtmlString:titletext];
        //⚠️字体需要在这里重新设置才行，不然会变小
        title.font = NewsTitleFont;
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
    [title updateLayout];
}



@end
