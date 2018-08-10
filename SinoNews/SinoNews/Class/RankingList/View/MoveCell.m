//
//  MoveCell.m
//  veryGood
//
//  Created by dllo on 16/11/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "MoveCell.h"
#import "RankingModel.h"


#define SCellHeight 150

#define BCellHeight 230

//普通字体大小
#define FontSize 16

@interface MoveCell ()

@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *updateTime;

@end

@implementation MoveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //取消cell点击的效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCellHeight)];
        [self.contentView addSubview:self.imageV];

        UIView *backView = [UIView new];
        backView.backgroundColor = HexColorAlpha(#000000, 0.3);
        [self.imageV addSubview:backView];
        backView.sd_layout
        .leftEqualToView(self.imageV)
        .rightEqualToView(self.imageV)
        .topEqualToView(self.imageV)
        .bottomEqualToView(self.imageV)
        ;

        self.label = [UILabel new];
        self.label.numberOfLines = 1;
        self.label.font = PFFontM(24);
        self.label.textAlignment =  NSTextAlignmentCenter;
        self.label.textColor = WhiteColor;
        
        self.updateTime = [UILabel new];
        self.updateTime.font = PFFontM(11);
        self.updateTime.textColor = WhiteColor;
        self.updateTime.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.updateTime];
        
        self.label.sd_layout
        .centerXEqualToView(self.contentView)
        .centerYEqualToView(self.imageV)
        .autoHeightRatio(0)
        ;
        [self.label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.updateTime.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.label, 5)
        .autoHeightRatio(0)
        ;
        [self.updateTime setSingleLineAutoResizeWithMaxWidth:200];
        
        //添加点击方法
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.imageV addGestureRecognizer:tapG];
        
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)gestur
{
//    NSLog(@"点击了%ld", gestur.view.tag);
}
- (void)cellOffsetOnTabelView:(UITableView *)tabelView
{
    
    CGFloat currentLocation = tabelView.contentOffset.y + BCellHeight;
    
    //如果超出规定的位置以 ->“上”
    if (self.frame.origin.y < tabelView.contentOffset.y + BCellHeight - SCellHeight) {
        NSLog(@"cell:%.2f", currentLocation - SCellHeight);
        self.imageV.height = BCellHeight;
        
        self.imageV.y = - (BCellHeight - SCellHeight);
       
//        self.label.font = [UIFont systemFontOfSize:FontSize * 4];
        
    }else if (self.frame.origin.y <= currentLocation && self.frame.origin.y >= tabelView.contentOffset.y) {
        //cell开始进入规定的位置
        
        //通过绝对值 取出移动的Y值
        CGFloat moveY = ABS(self.frame.origin.y - currentLocation) / SCellHeight * (BCellHeight - SCellHeight);
        
        [[self superview] bringSubviewToFront:self];
        
        //移动的值 + cell固定高度
        self.imageV.height = SCellHeight + moveY;
//        self.label.height = SCellHeight + moveY;
        //设置偏移量Y值
//        self.label.y = - moveY;
        self.imageV.y = - moveY;
        //通过move改变字体的大小 倍数 与起始变化位置自己定义 这里以最大值4倍计算
//        if (BCellHeight - SCellHeight > moveY && moveY > 20) {
//
//            self.label.font = [UIFont systemFontOfSize:FontSize * moveY / 20];
//
//        } else if (moveY <= 20)
//        {
//            self.label.font = [UIFont systemFontOfSize:FontSize];
//        } else {
//            self.label.font = [UIFont systemFontOfSize:FontSize * 4];
//        }
        
    }else{
        //超出规定的位置以 ->“下”
        
        self.imageV.height = SCellHeight;
        
        self.imageV.y = 0;
        
//        self.label.font = [UIFont systemFontOfSize:FontSize];
    }
}

- (void)cellGetImage:(NSString *)str tag:(NSInteger)tag
{
    self.imageV.tag = tag;
    self.imageV.image = [UIImage imageNamed:str];
}

-(void)cellGetModel:(RankingModel *)model tag:(NSInteger)tag
{
    self.imageV.tag = tag;
    [self.imageV sd_setImageWithURL:UrlWithStr(GetSaveString(model.rankingLogo))];
    self.label.text = GetSaveString(model.rankingName);
    self.updateTime.text = GetSaveString(model.updateTime);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
