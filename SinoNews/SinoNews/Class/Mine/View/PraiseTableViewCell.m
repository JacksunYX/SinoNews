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
NSInteger static maxNum = 6;
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
    comment.font = PFFontL(14);
    comment.textAlignment = NSTextAlignmentRight;
    
    title = [UILabel new];
    title.font = PFFontL(15);
    
    time = [UILabel new];
    time.font = PFFontL(11);
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
    .rightSpaceToView(comment, 20)
    .heightIs(16)
    ;
    
    time.sd_layout
    .leftEqualToView(title)
    .rightEqualToView(title)
    .topSpaceToView(title, 10)
    .heightIs(12)
    ;
    
    CGFloat wid = 25 * maxNum + 5 * (maxNum - 1);
    iconView.sd_layout
    .leftSpaceToView(father, 10)
//    .bottomSpaceToView(father, 10)
    .topSpaceToView(time, 10)
    .widthIs(wid)
    .heightIs(25)
    ;
    [self setupAutoHeightWithBottomView:iconView bottomMargin:10];
}

-(void)setModel:(PraiseHistoryModel *)model
{
    _model = model;
    NSArray *praise = model.praiseUserInfo;
//    NSString *titleStr = @"";
    
    for (UIView *view in iconView.subviews) {
        [view removeFromSuperview];
    }
    if (praise.count <= 0){
        
    }else{
//        if (praise.count > 1) {
//            NSDictionary *firstModel = [praise firstObject];
//            titleStr = [NSString stringWithFormat:@"%@等%ld人赞了你",GetSaveString(firstModel[@"name"]),praise.count];
//        }else{
//            NSDictionary *firstModel = [praise firstObject];
//            titleStr = [NSString stringWithFormat:@"%@赞了你",GetSaveString(firstModel[@"name"])];
//        }
        //添加头像
        CGFloat wid = 25;
        CGFloat marginX = 5;
        for (int i = 0; i < praise.count; i ++) {
            if (i == maxNum) {
                //最多显示6张
                break;
            }
            UIImageView *icon = [UIImageView new];
            [iconView addSubview:icon];
            icon.sd_layout
            .leftSpaceToView(iconView, (wid + marginX) * i)
            .topEqualToView(iconView)
            .widthIs(wid)
            .heightEqualToWidth()
            ;
            [icon setSd_cornerRadius:@(wid/2)];
            UserModel *user = praise[i];
//            icon.image = UIImageNamed(GetSaveString(praise[i][@"icon"]));
            [icon sd_setImageWithURL:UrlWithStr(GetSaveString(user.avatar))];
        }
        
    }
    
    title.text = GetSaveString(model.tipMessage);
    
    time.text = GetSaveString(model.cutOffTime);
    
    comment.text = GetSaveString(model.content);
    
}


@end
