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
    UILabel *title;
    UILabel *bottomLabel;
    UILabel *typeLabel;
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
    title.font = FontScale(17);
    title.textColor = HexColor(#323232);
    
    bottomLabel = [UILabel new];
    bottomLabel.font = FontScale(11);
    bottomLabel.textColor = HexColor(#989898);
    bottomLabel.isAttributedContent = YES;
    
    typeLabel = [UILabel new];
    typeLabel.font = FontScale(11);
    typeLabel.backgroundColor = WhiteColor;
    typeLabel.textColor = HexColor(#1282EE);
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.borderColor = HexColor(#1282EE).CGColor;
    typeLabel.layer.borderWidth = 1;
    
    [self.contentView sd_addSubviews:@[
                                       title,
                                       bottomLabel,
                                       typeLabel,
                                       
                                       ]];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .autoHeightRatio(0)
    ;
//    [title setMaxNumberOfLinesToShow:3];
    
    bottomLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
//    .bottomEqualToView(rightImg)
    .topSpaceToView(title, 10)
    .autoHeightRatio(0)
    ;
//    [bottomLabel setMaxNumberOfLinesToShow:1];
    
    typeLabel.sd_layout
    .leftEqualToView(title)
//    .topEqualToView(title)
    .topSpaceToView(self.contentView, 13)
    .heightIs(ScaleW * 17)
    .widthIs(ScaleW * 17 + 10)
    ;
    [typeLabel  setSd_cornerRadius:@4];
//    [typeLabel cornerWithRadius:2];
   
    [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:15];
}

-(void)setModel:(HomePageModel *)model
{
    _model = model;
    
    NSString *labelName = GetSaveString(model.labelName);
    if (kStringIsEmpty(labelName)) {
        title.text = GetSaveString(model.itemTitle);
        typeLabel.hidden = YES;
    }else{
        title.text = [@"        " stringByAppendingString:GetSaveString(model.itemTitle)];
        typeLabel.hidden = NO;
    }
    
    NSString *str1 = [@"" stringByAppendingString:@"  "];
    NSString *str2 = [GetSaveString(model.username) stringByAppendingString:@"  "];
    NSString *str3 = [[NSString stringWithFormat:@"%ld",model.viewCount] stringByAppendingString:@" 阅  "];
    NSString *str4 = [[NSString stringWithFormat:@"%ld",model.commentCount] stringByAppendingString:@" 评"];
    NSString *totalStr = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:totalStr];
    //    NSDictionary *dic1 = @{
    //                           NSForegroundColorAttributeName:HexColor(#1282EE),
    //                           NSFontAttributeName:FontScale(11),
    //                           };
    //    [attString addAttributes:dic1 range:NSMakeRange(0, str1.length)];
    bottomLabel.attributedText = attString;
    
    typeLabel.text = GetSaveString(model.labelName);
}




@end
