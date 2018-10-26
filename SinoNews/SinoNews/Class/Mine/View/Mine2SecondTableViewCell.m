//
//  Mine2SecondTableViewCell.m
//  SinoNews
//
//  Created by Michael on 2018/10/26.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "Mine2SecondTableViewCell.h"

NSString *const Mine2SecondTableViewCellID = @"Mine2SecondTableViewCellID";

@interface Mine2SecondTableViewCell ()
{
    UIImageView *backView;
    UILabel *title;
}
@end

@implementation Mine2SecondTableViewCell

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
    CGFloat TBX = 5;
    backView = [UIImageView new];
//    backView.backgroundColor = RedColor;
    backView.userInteractionEnabled = YES;
    backView.contentMode = 2;
    [self.contentView addSubview:backView];
    
    backView.sd_layout
    .leftSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, TBX)
    .heightIs(120)
    ;
    [backView updateLayout];
    backView.lee_theme.LeeConfigImage(@"mine_Shadow_big");
    
    title = [UILabel new];
    title.font = PFFontR(15);
    [title addTitleColorTheme];
    [backView addSubview:title];
    title.sd_layout
    .topSpaceToView(backView, 20)
    .leftSpaceToView(backView, 20)
    .heightIs(15)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    [self setupAutoHeightWithBottomView:backView bottomMargin:TBX];
}

-(void)setData:(NSDictionary *)data
{
    //先移除所有的视图
    for (UIView *subView in backView.subviews) {
        if (subView != title) {
            [subView removeFromSuperview];
        }
    }
    title.text = data[@"title"];
    //再添加
    NSArray *dataArr = data[@"dataArr"];
    for (int i = 0; i < dataArr.count; i ++) {
        UIView *view = [UIView new];
        view.tag = 10005 + i;
        [backView addSubview:view];
        CGFloat avgW = (ScreenW - 30)/dataArr.count;
        view.sd_layout
        .leftSpaceToView(backView, avgW * i)
        .topSpaceToView(title, 20)
        .bottomEqualToView(backView)
        .widthIs(avgW)
        ;
        [view updateLayout];
        NSDictionary *dataDic = dataArr[i];
        //添加图标和文字
        UIImageView *icon = [UIImageView new];
        icon.userInteractionEnabled = YES;
        icon.contentMode = 1;
        UILabel *subTitle = [UILabel new];
        subTitle.userInteractionEnabled = YES;
        subTitle.font = PFFontL(12);
        [subTitle addContentColorTheme];
        subTitle.textAlignment = NSTextAlignmentCenter;
        [view sd_addSubviews:@[
                               icon,
                               subTitle,
                               ]];
        icon.sd_layout
        .centerXEqualToView(view)
        .topEqualToView(view)
        .widthIs(24)
        .heightEqualToWidth()
        ;
        [icon updateLayout];
        icon.image = UIImageNamed(dataDic[@"icon"]);
        
        subTitle.sd_layout
        .topSpaceToView(icon, 10)
//        .bottomEqualToView(view)
        .leftEqualToView(view)
        .rightEqualToView(view)
        .heightIs(14)
        ;
        subTitle.text = dataDic[@"subTitle"];
        [subTitle updateLayout];
        
        @weakify(self);
        @weakify(view);
        [view whenTap:^{
            @strongify(self);
            @strongify(view);
            if (self.clickBlock) {
                self.clickBlock(view.tag - 10005);
            }
        }];
    }
}

@end
