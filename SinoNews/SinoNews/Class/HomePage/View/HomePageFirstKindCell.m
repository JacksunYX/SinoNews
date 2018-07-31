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
    UILabel *tlLabel;  //左上标签
    UILabel *title;
    UIImageView *rightImg;
    
    UILabel *blLabel;     //左下标签
    UILabel *bottomLabel;
}
@end

@implementation HomePageFirstKindCell

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
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    rightImg = [UIImageView new];
    rightImg.userInteractionEnabled = YES;
    rightImg.contentMode = 2;
    //    rightImg.backgroundColor = Arc4randomColor;
    
    title = [UILabel new];
    title.font = FontScale(17);
//    title.textColor = HexColor(#323232);
    
    tlLabel = [UILabel new];
    tlLabel.font = FontScale(11);
    tlLabel.backgroundColor = WhiteColor;
    tlLabel.textColor = HexColor(#1282EE);
    tlLabel.textAlignment = NSTextAlignmentCenter;
    
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
                                       rightImg,
                                       title,
                                       tlLabel,
                                       blLabel,
                                       bottomLabel,
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
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:3];
    
    tlLabel.sd_layout
    .leftEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 17)
    .widthIs(ScaleW * 17 + 10)
    ;
    [tlLabel setSd_cornerRadius:@2];
    
    blLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .bottomEqualToView(rightImg)
    .autoHeightRatio(0)
    ;
    [blLabel setSingleLineAutoResizeWithMaxWidth:50];
    
    bottomLabel.sd_layout
    .leftSpaceToView(blLabel, 0)
    .rightSpaceToView(rightImg, 10)
    .bottomEqualToView(rightImg)
    .autoHeightRatio(0)
    ;
    [bottomLabel setMaxNumberOfLinesToShow:1];
    
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
        NSString *imgStr = [model.images firstObject];
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
    }else{
        rightImg.image = nil;
    }
    
    
}


@end
