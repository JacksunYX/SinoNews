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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    title = [UILabel new];
    title.font = FontScale(17);
    title.textColor = HexColor(#323232);
//    title.backgroundColor = Arc4randomColor;
    
    rightImg = [UIImageView new];
    rightImg.userInteractionEnabled = YES;
    rightImg.backgroundColor = Arc4randomColor;
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(11);
    bottomLabel.textColor = HexColor(#989898);
//    bottomLabel.backgroundColor = Arc4randomColor;
    bottomLabel.isAttributedContent = YES;
    
    typeLabel = [UILabel new];
    typeLabel.font = FontScale(11);
    typeLabel.backgroundColor = HexColor(#1282EE);
    typeLabel.textColor = WhiteColor;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView sd_addSubviews:@[
                                       rightImg,
                                       title,
                                       bottomLabel,
                                       typeLabel,
                                       
                                       ]];
    //布局
    rightImg.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(kScaelW(130))
    .heightIs(kScaelW(130)*80/130)
    ;
    [rightImg setSd_cornerRadius:@4];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    title.text = [@"        " stringByAppendingString:@"发改委：严格防范外 债严格防范外债"];
    
    bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(rightImg, 10)
    .bottomEqualToView(rightImg)
    .autoHeightRatio(0)
    ;
    [bottomLabel setMaxNumberOfLinesToShow:1];
    
    NSString *str1 = [@"问答" stringByAppendingString:@"  "];
    NSString *str2 = [@"环球国际时报" stringByAppendingString:@"  "];
    NSString *str3 = [@"12321" stringByAppendingString:@" 阅  "];
    NSString *str4 = [@"23812" stringByAppendingString:@" 评"];
    NSString *totalStr = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSDictionary *dic1 = @{
                           NSForegroundColorAttributeName:HexColor(#1282EE),
                           NSFontAttributeName:FontScale(11),
                           };
    [attString addAttributes:dic1 range:NSMakeRange(0, str1.length)];
    bottomLabel.attributedText = attString;
    
    typeLabel.sd_layout
    .leftEqualToView(title)
    .topEqualToView(title)
    .heightIs(ScaleW * 17)
    .widthIs(ScaleW * 17 + 10)
    ;
    [typeLabel setSd_cornerRadius:@2];
//    [typeLabel setSingleLineAutoResizeWithMaxWidth:100];
    typeLabel.text = @"推荐";
//    [typeLabel updateLayout];
//    typeLabel.frame = CGRectMake(typeLabel.frame.origin.x, typeLabel.frame.origin.y, typeLabel.frame.size.width + kScaelW(10), typeLabel.frame.size.height + kScaelW(10));
}




@end
