//
//  PraiseTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/12.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "PraiseTableViewCell.h"

@interface PraiseTableViewCell ()
{
    UILabel *title;
    UILabel *time;
    UILabel *comment;
    UIView *iconView;
}
@end

@implementation PraiseTableViewCell

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
        [self setUI];
    }
    return self;
}

-(void)setUI
{
    comment = [UILabel new];
    comment.font = Font(14);
    comment.textAlignment = NSTextAlignmentRight;
    
    title = [UILabel new];
    title.font = Font(15);
    
    time = [UILabel new];
    time.font = Font(11);
    time.textColor = RGBA(152, 152, 152, 1);
    
    iconView = [UIView new];
    
    UIView *father = self.contentView;
    
    [father sd_addSubviews:@[
                                       comment,
                                       title,
                                       time,
                                       iconView,
                                       ]];
    comment.sd_layout
    .rightSpaceToView(father, 10)
    .topSpaceToView(father, 8)
    .widthIs(70)
    .autoHeightRatio(0)
    ;
    [comment setMaxNumberOfLinesToShow:3];
    
    title.sd_layout
    .leftSpaceToView(father, 10)
    .topSpaceToView(father, 9)
    .rightSpaceToView(father, 20)
    .autoHeightRatio(0)
    ;
    [title setMaxNumberOfLinesToShow:1];
    
    time.sd_layout
    .leftEqualToView(title)
    .rightEqualToView(title)
    .topSpaceToView(title, 10)
    .autoHeightRatio(0)
    ;
    [time setMaxNumberOfLinesToShow:1];
    
    CGFloat wid = 25 * 6 + 5 * 5;
    iconView.sd_layout
    .leftSpaceToView(father, 10)
    .bottomSpaceToView(father, 10)
    .widthIs(wid)
    .heightIs(25)
    ;
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    NSArray *praise = model[@"praises"];
    NSString *titleStr = @"";
    
    for (UIView *view in iconView.subviews) {
        [view removeFromSuperview];
    }
    if (praise.count <= 0){
        
    }else{
        if (praise.count > 1) {
            NSDictionary *firstModel = [praise firstObject];
            titleStr = [NSString stringWithFormat:@"%@等%ld人赞了你",GetSaveString(firstModel[@"name"]),praise.count];
        }else{
            NSDictionary *firstModel = [praise firstObject];
            titleStr = [NSString stringWithFormat:@"%@赞了你",GetSaveString(firstModel[@"name"])];
        }
        //添加头像
        CGFloat wid = 25;
        CGFloat marginX = 5;
        for (int i = 0; i < praise.count; i ++) {
            UIImageView *icon = [UIImageView new];
            [iconView addSubview:icon];
            icon.sd_layout
            .leftSpaceToView(iconView, (wid + marginX) * i)
            .topEqualToView(iconView)
            .widthIs(wid)
            .heightEqualToWidth()
            ;
            [icon setSd_cornerRadius:@(wid/2)];
            icon.image = UIImageNamed(GetSaveString(praise[i][@"icon"]));
        }
        
    }
    
    title.text = titleStr;
    
    time.text = GetSaveString(model[@"time"]);
    
    comment.text = GetSaveString(model[@"comment"]);
    
}


@end
