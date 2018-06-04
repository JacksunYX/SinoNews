//
//  LineCollectionViewCell.m
//  CollectionView-LineLayout
//
//  Created by Kobe24 on 2018/1/2.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "LineCollectionViewCell.h"
#import "LineLayout.h"

@interface LineCollectionViewCell ()
{
    UIImageView *backImg;
    UILabel *title;
    UILabel *updateTime;
}

@end

@implementation LineCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WhiteColor;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    backImg = [UIImageView new];
    backImg.backgroundColor = Arc4randomColor;
    
    title = [UILabel new];
    title.font = FontScale(14);
    title.textColor = WhiteColor;
    title.textAlignment = NSTextAlignmentCenter;
    
    updateTime = [UILabel new];
    updateTime.font = FontScale(14);
    updateTime.textColor = WhiteColor;
    updateTime.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView sd_addSubviews:@[
                                       backImg,
                                       title,
                                       updateTime,
                                       ]];
    //布局
    backImg.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    ;
    
    title.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 35)
    .autoHeightRatio(0)
    ;
    [title setSingleLineAutoResizeWithMaxWidth:200];
    
    updateTime.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(title, 5)
    .autoHeightRatio(0)
    ;
    [updateTime setSingleLineAutoResizeWithMaxWidth:200];
    
}

-(void)setModel:(NSDictionary *)model
{
    _model = model;
    backImg.image = UIImageNamed(model[@"backImg"]);
    title.text = model[@"title"];
    updateTime.text = model[@"updateTime"];
}

@end