//
//  BrowsingHistoryCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "BrowsingHistoryCell.h"

@interface BrowsingHistoryCell ()
{
    UILabel *title;
    UILabel *subTitle;
    UIImageView *img;
}
@end

@implementation BrowsingHistoryCell

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
    img = [UIImageView new];
    title = [UILabel new];
    title.font = Font(15);
    
    subTitle = [UILabel new];
    subTitle.font = Font(12);
    subTitle.textColor = RGBA(152, 152, 152, 1);
    
    [self.contentView sd_addSubviews:@[
                                       img,
                                       title,
                                       subTitle,
                                       
                                       ]];
    img.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .widthIs(130)
    .heightIs(80)
    ;
    [img setSd_cornerRadius:@4];
    
    title.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 19)
    .rightSpaceToView(img, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:2];
    
    subTitle.sd_layout
    .leftEqualToView(title)
    .bottomSpaceToView(self.contentView, 20)
    .rightSpaceToView(img, 20)
    .autoHeightRatio(0)
    ;
    [subTitle setMaxNumberOfLinesToShow:1];

}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    
    img.image = UIImageNamed(GetSaveString(model[@"newsImg"]));
    title.text = GetSaveString(model[@"newsTitle"]);
    subTitle.text = [GetSaveString(model[@"browsTime"]) stringByAppendingString:[NSString stringWithFormat:@" | %@",GetSaveString(model[@"newsAuthor"])]];
}





@end
