//
//  ThePostListTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/30.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ThePostListTableViewCell.h"

NSString * _Nullable const ThePostListTableViewCellID = @"ThePostListTableViewCellID";

@interface ThePostListTableViewCell ()
{
    UILabel *title;
    UILabel *bottomLabel;
    UILabel *readNum;
}
@end

@implementation ThePostListTableViewCell

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
        
        [self setUI];
        
    }
    return self;
}

-(void)setUI
{
    title = [UILabel new];
//    title.textColor = HexColor(#161A24);
    [title addTitleColorTheme];
    title.font = PFFontL(15);
    title.isAttributedContent = YES;
    
    bottomLabel = [UILabel new];
//    bottomLabel.textColor = HexColor(#ABB2C3);
    [bottomLabel addContentColorTheme];
    bottomLabel.font = PFFontL(12);
    
    readNum = [UILabel new];
    readNum.textColor = HexColor(#ABB2C3);
    readNum.font = PFFontL(12);
    readNum.textAlignment = NSTextAlignmentRight;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 title,
                                 bottomLabel,
                                 readNum,
                                 ]];
    title.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 15)
    .rightSpaceToView(fatherView, 50)
    .autoHeightRatio(0)
    ;
    
    bottomLabel.sd_layout
    .leftEqualToView(title)
    .rightSpaceToView(fatherView, 50)
    .topSpaceToView(title, 15)
    .heightIs(14)
    ;
    
    readNum.sd_layout
    .rightSpaceToView(fatherView, 10)
    .centerYEqualToView(bottomLabel)
    .leftSpaceToView(title, 10)
    .heightRatioToView(bottomLabel, 1)
    ;
    
    [self setupAutoHeightWithBottomView:bottomLabel bottomMargin:15];
}

-(void)setData:(NSDictionary *)model
{
    title.text = @"你们summer rate的snp都到了么";
    bottomLabel.text = @"IHG优悦会  09-12";
    readNum.text = @"4评论";
}

-(void)setModel:(SeniorPostDataModel *)model
{
    _model = model;
    NSString *titletext = GetSaveString(model.postTitle);
    //判断是否包含标签文字
    if ([titletext containsString:@"<font"]) {
        //记录一下最开始的字体
        UIFont *font = title.font;
        //解析
        title.attributedText = [NSString analysisHtmlString:titletext];
        //⚠️字体需要在这里重新设置才行，不然会变小
        title.font = font;
        
    }else{
        title.text = titletext;
    }
    [title updateLayout];
    
    bottomLabel.text = [NSString stringWithFormat:@"%@  %@",GetSaveString(model.author),GetSaveString(model.createTime)];
    readNum.text = [NSString stringWithFormat:@"%ld评论",model.commentCount];
}

@end
