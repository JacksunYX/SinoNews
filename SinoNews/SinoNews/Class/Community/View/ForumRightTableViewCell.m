//
//  ForumRightTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/24.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "ForumRightTableViewCell.h"

NSString *const ForumRightTableViewCellID = @"ForumRightTableViewCellID";

@interface ForumRightTableViewCell ()
{
    UIImageView *logo;
    UILabel *communityName;
    UILabel *postNum;
}
@end

@implementation ForumRightTableViewCell

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
    logo = [UIImageView new];
    
    communityName = [UILabel new];
    communityName.font = PFFontM(14);
    
    postNum = [UILabel new];
    postNum.font = PFFontM(12);
    postNum.textColor = LightGrayColor;
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 logo,
                                 communityName,
                                 postNum,
                                 ]];
    logo.sd_layout
    .leftSpaceToView(fatherView, 10)
    .topSpaceToView(fatherView, 10)
    .widthIs(40)
    .heightEqualToWidth()
    ;
    
    communityName.sd_layout
    .leftSpaceToView(logo, 15)
    .centerYEqualToView(logo)
    .heightIs(16)
    ;
    [communityName setSingleLineAutoResizeWithMaxWidth:100];
    
    postNum.sd_layout
    .rightSpaceToView(fatherView, 15)
    .centerYEqualToView(logo)
    .heightIs(14)
    ;
    [postNum setSingleLineAutoResizeWithMaxWidth:50];
    
    [self setupAutoHeightWithBottomView:logo bottomMargin:10];
}

-(void)setData:(NSDictionary *)model
{
    logo.image = UIImageNamed(model[@"logo"]);
    communityName.text = model[@"communityName"];
    postNum.text = [NSString stringWithFormat:@"%u篇",arc4random()%500+10];
}

@end
