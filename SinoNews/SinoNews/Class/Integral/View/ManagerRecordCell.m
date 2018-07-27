//
//  ManagerRecordCell.m
//  SinoNews
//
//  Created by Michael on 2018/6/4.
//  Copyright © 2018年 Sino. All rights reserved.
//

#import "ManagerRecordCell.h"

@interface ManagerRecordCell ()
{
    UILabel *behavior;
    UILabel *time;
    UILabel *integerChange;
    UILabel *balance;
}
@end

@implementation ManagerRecordCell

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
        self.backgroundColor = WhiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIView *leftLine = [UIView new];
    
    UIView *rightLine = [UIView new];
    
    UIView *bottomLine = [UIView new];
    
    self.lee_theme.LeeCustomConfig(@"backgroundColor", ^(id item, id value) {
        [(UITableViewCell *)item setBackgroundColor:value];
        
        leftLine.backgroundColor = CutLineColor;
        rightLine.backgroundColor = CutLineColor;
        bottomLine.backgroundColor = CutLineColor;
        if (UserGetBool(@"NightMode")) {
            
            leftLine.backgroundColor = CutLineColorNight;
            rightLine.backgroundColor = CutLineColorNight;
            bottomLine.backgroundColor = CutLineColorNight;
        }
    });
    
    UIView *fatherView = self.contentView;
    [fatherView sd_addSubviews:@[
                                 leftLine,
                                 rightLine,
                                 bottomLine,
                                 ]];
    CGFloat lrMargin = 10;
    CGFloat labelWid = (ScreenW - 2 * lrMargin)/4;
    leftLine.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    rightLine.sd_layout
    .rightSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(1)
    ;
    
    bottomLine.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .rightSpaceToView(fatherView, lrMargin)
    .bottomEqualToView(fatherView)
    .heightIs(1)
    ;
    
    [self setupAutoHeightWithBottomView:bottomLine bottomMargin:0];
    
    behavior = [UILabel new];
    behavior.font = Font(13);
    behavior.lee_theme.LeeCustomConfig(@"titleColor", ^(id item, id value) {
        if (UserGetBool(@"NightMode")) {
            [(UILabel *)item setTextColor:value];
        }else{
            [(UILabel *)item setTextColor:RGBA(68, 68, 68, 1)];
        }
    });
    behavior.textAlignment = NSTextAlignmentCenter;
    behavior.numberOfLines = 2;
    behavior.isAttributedContent = YES;
    
    time = [UILabel new];
    time.font = Font(12);
    time.textColor = RGBA(152, 152, 152, 1);
    time.textAlignment = NSTextAlignmentCenter;
    time.numberOfLines = 2;
    
    integerChange = [UILabel new];
    integerChange.font = Font(12);
    
    integerChange.textAlignment = NSTextAlignmentCenter;
    integerChange.numberOfLines = 2;
    
    balance = [UILabel new];
    balance.font = Font(12);
    balance.textColor = RGBA(152, 152, 152, 1);
    balance.textAlignment = NSTextAlignmentCenter;
    balance.numberOfLines = 2;
    
    [fatherView sd_addSubviews:@[
                                 behavior,
                                 time,
                                 integerChange,
                                 balance,
                                 ]];
    
    behavior.sd_layout
    .leftSpaceToView(fatherView, lrMargin)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
    
    time.sd_layout
    .leftSpaceToView(behavior, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
    
    integerChange.sd_layout
    .leftSpaceToView(time, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
    
    balance.sd_layout
    .leftSpaceToView(integerChange, 0)
    .topEqualToView(fatherView)
    .bottomEqualToView(fatherView)
    .widthIs(labelWid)
    ;
}

-(void)setModel:(IntegralModel *)model
{
    _model = model;
//    NSString *behaviorStr = GetSaveString(model[@"behavior"]);
//    NSString *subBehaviorStr = GetSaveString(model[@"subBehavior"]);
//    NSString *totalStr = [NSString stringWithFormat:@"%@\n%@",behaviorStr,subBehaviorStr];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
//    NSDictionary *attDic = @{
//                             NSFontAttributeName:Font(12),
//                             NSForegroundColorAttributeName:RGBA(136, 136, 136, 1),
//                             };
//    NSLog(@"totalStr.length:%ld",totalStr.length);
//    NSLog(@"attStr:%ld",attStr.length);
//    [attStr addAttributes:attDic range:NSMakeRange((totalStr.length - subBehaviorStr.length), subBehaviorStr.length)];
//    behavior.attributedText = attStr;
//    NSLog(@"behavior:%@",behaviorStr);
    behavior.text = GetSaveString(model.pointsType);
    time.text = GetSaveString(model.time);
    integerChange.text = GetSaveString(model.pointsChange);
    if ([model.pointsChange containsString:@"-"]) {
        integerChange.textColor = RGBA(152, 152, 152, 1);
    }else{
        integerChange.textColor = RGBA(118, 179, 239, 1);
    }
    balance.text = [NSString stringWithFormat:@"%ld",model.remialPoints];
}





@end
