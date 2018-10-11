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
    title.font = NewsTitleFont;
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
        .widthIs(kScaelW(118))
        .heightIs(kScaelW(118)*82/118)
//    .widthIs(kScaelW(105))
//    .heightEqualToWidth()
    ;
    [rightImg setSd_cornerRadius:@4];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 15)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    
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
    .heightIs([FontScale(12) pointSize])
    ;
    [blLabel setSingleLineAutoResizeWithMaxWidth:80];
    
    bottomLabel.sd_layout
    .leftSpaceToView(blLabel, 0)
    .rightSpaceToView(rightImg, 10)
    .bottomEqualToView(rightImg)
    .heightIs([FontScale(12) pointSize])
    ;
    
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
    
    bottomLabel.textColor = HexColor(#889199);
    
    [title addTitleColorTheme];
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
            str1 = AppendingString(GetSaveString(model.username), @"  ");
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
        //不知道为何，显示有问题，只有自己在首位拼接一下字体标签
        if (UserGetBool(@"NightMode")) {
            titletext = [@"<font color='white'>" stringByAppendingString:titletext];
            titletext = [titletext stringByAppendingString:@"</font>"];
        }else{
            titletext = [@"<font color='black'>" stringByAppendingString:titletext];
            titletext = [titletext stringByAppendingString:@"</font>"];
        }
        
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
    
//    @weakify(self)
//    rightImg.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
//        @strongify(self)
//        UIImageView *imageView = item;
//        if (self.model.images.count>0) {
//            NSString *imgStr = [self.model.images firstObject];
//            if (UserGetBool(@"NightMode")) {
//                [imageView sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:UIImageNamed(@"placeholder_logo_small_night")];
//            }else{
//               [imageView sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:UIImageNamed(@"placeholder_logo_small")];
//            }
//        }else{
//            imageView.image = nil;
//        }
//    });
    
    if (self.model.images.count>0) {
        NSString *imgStr = [self.model.images firstObject];
        
        [rightImg sd_setImageWithURL:UrlWithStr(GetSaveString(imgStr)) placeholderImage:[self placeholderImageStr]];
    }else{
        rightImg.image = [self placeholderImageStr];
    }
}

//获取当前应当显示的占位图
-(UIImage *)placeholderImageStr
{
    NSString *imgUrl = @"placeholder_logo";
    if (UserGetBool(@"NightMode")) {
        imgUrl = [imgUrl stringByAppendingString:@"_night"];
    }else{
        imgUrl = [imgUrl stringByAppendingString:@"_day"];
    }
    return UIImageNamed(imgUrl);
}

@end
