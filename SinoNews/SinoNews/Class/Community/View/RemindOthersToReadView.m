//
//  RemindOthersToReadView.m
//  SinoNews
//
//  Created by Michael on 2018/11/5.
//  Copyright © 2018 Sino. All rights reserved.
//

#import "RemindOthersToReadView.h"
#import "MyFansModel.h"

@interface RemindOthersToReadView ()
{
    
}

@end

@implementation RemindOthersToReadView

-(instancetype)init
{
    if (self == [super init]) {
        _remindArr = [NSMutableArray new];
    }
    return self;
}

-(void)setRemindArr:(NSMutableArray *)remindArr
{
    _remindArr = remindArr;
    [self setUI];
}

-(void)setUI
{
    [self removeAllSubviews];
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.font = PFFontL(15);
    leftLabel.textColor = HexColor(#1282EE);
    [self addSubview:leftLabel];
    leftLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 10)
    .heightIs(18)
    ;
    [leftLabel setSingleLineAutoResizeWithMaxWidth:100];
    leftLabel.text = @"@提醒谁看";
    
    UIImageView *rightArrow = [UIImageView new];
    [self addSubview:rightArrow];
    rightArrow.sd_layout
    .rightSpaceToView(self, 10)
    .centerYEqualToView(self)
    .widthIs(6)
    .heightIs(10)
    ;
    rightArrow.image = UIImageNamed(@"rightArrow_icon");
    
    if (_remindArr.count<=0) {
        UILabel *rightLabel = [UILabel new];
        rightLabel.font = PFFontL(12);
        rightLabel.textColor = HexColor(#939393);
        [self addSubview:rightLabel];
        rightLabel.sd_layout
        .centerYEqualToView(self)
        .rightSpaceToView(rightArrow, 10)
        .heightIs(18)
        ;
        [rightLabel setSingleLineAutoResizeWithMaxWidth:100];
        rightLabel.text = @"请选择";
        
        return;
    }
    
    //添加右方视图
    UIView *rightView = [UIView new];
    [self addSubview:rightView];
    rightView.sd_layout
    .widthIs(132)
    .rightSpaceToView(rightArrow, 10)
    .centerYEqualToView(self)
    ;
    
    CGFloat avgSpaceX = 3;
    CGFloat avgSpaceY = 5;
    CGFloat avgW = 24;
    CGFloat avgH = avgW;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat totalW = avgW * 5 + avgSpaceX * 4;
    UIView *lastView;
    for (int i = 0; i < _remindArr.count; i ++) {
        CGFloat currentX = totalW - x - avgW;
        CGFloat currentY = y;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(currentX, currentY, avgW, avgH)];
        [imageView cornerWithRadius:avgW/2];
//        imageView.backgroundColor = Arc4randomColor;
        imageView.tag = 10099 + i;
        [rightView addSubview:imageView];
        RemindPeople *model = _remindArr[i];
        [imageView sd_setImageWithURL:UrlWithStr(model.avatar)];
        
        NSInteger morethan = (i+1)%5;
        if (morethan == 0) {
            //此时需要换行
            y += avgH + avgSpaceY;
        }
        
        x = (avgSpaceX + avgW) * morethan;
        
        if (i == _remindArr.count-1) {
            lastView = imageView;
        }
    }
    if (lastView) {
        [rightView setupAutoHeightWithBottomView:lastView bottomMargin:0];
    }
}

@end
