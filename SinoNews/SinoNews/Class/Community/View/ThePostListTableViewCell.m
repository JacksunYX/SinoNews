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
    .rightEqualToView(title)
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

@end
